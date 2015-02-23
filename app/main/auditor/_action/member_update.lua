local id = param.get_id()
local member = Member:by_id(id)
local res1,res2

if not member then
  member = Member:new()
  member.creator_id = app.session.member_id
  res1 = db:query("SELECT COUNT(*) from member WHERE nin = '"..string.upper(param.get("nin")).."'")[1][1]
elseif member.certifier_id ~= app.session.member_id then
  slot.put_into("error", _"You cannot modify an user not created by you!")
  return false
else
  res1 = db:query("SELECT COUNT(*) from member WHERE nin = '"..string.upper(param.get("nin")).."' AND id !="..member.id)[1][1]
end

local member_data = MemberData:by_id(id) 
if not member_data then
  member_data = MemberData:new()
  member.certifier_id = app.session.member_id
  member.certified = atom.timestamp:get_current()
  res2 = secure_db:query("SELECT COUNT(*) from member_data WHERE idcard = '"..param.get("idcard").."'")[1][1]
  res3 = secure_db:query("SELECT COUNT(*) from member_data WHERE token_serial ='"..param.get("token_serial").."'")[1][1]
else
  res2 = secure_db:query("SELECT COUNT(*) from member_data WHERE idcard = '"..param.get("idcard").."' AND id !="..member_data.id )[1][1]
  res3 = secure_db:query("SELECT COUNT(*) from member_data WHERE token_serial ='"..param.get("token_serial").."' AND id !="..member_data.id )[1][1]
end

if res1 > 0 then
  slot.put_into("error", _"Duplicate NIN value found in the database. User already registered.")
  return false
end

if res2 > 0 then
  slot.put_into("error", _"Duplicate Id Card Number value found in the database. User already registered.")
  return false
end

if res3 > 0 then
  slot.put_into("error", _"Duplicate Token Serial value found in the database. User already registered.")
  return false
end

local locked = param.get("locked", atom.boolean)
if locked ~= nil then
  member.locked = locked
end
local deactivate = param.get("deactivate", atom.boolean)
if deactivate then
  member.active = false
end

local elected = param.get("elected", atom.boolean)
if elected ~= nil then
    member.elected = elected
end

local auditor = param.get("auditor", atom.boolean)
if auditor ~= nil then
    member.auditor = auditor
end

local lqfb_access = param.get("lqfb_access", atom.boolean)
if lqfb_access ~= nil then
    member.lqfb_access = lqfb_access
end

local admin = param.get("admin", atom.boolean)
if admin ~= nil then
    member.admin = admin
end

-- Check user first name
local firstname = param.get("firstname")
if firstname then
  if #firstname >=2 then
    member.firstname = firstname
    member_data.firstname = firstname
  else
    slot.put_into("error", _"User first name is too short!")
    return false
  end
else
  if not member.firstname then
    slot.put_into("error", _"User first name cannot be empty!")
    return false
  end
end

-- Check user first name
local lastname = param.get("lastname")
if lastname then
  if #lastname >=2 then
    member.lastname = lastname
    member_data.lastname = lastname
  else
    slot.put_into("error", _"User last name is too short!")
    return false
  end
else
  if not member.lastname then
    slot.put_into("error", _"User last name cannot be empty!")
    return false
  end
end

-- Building name and realname field
if firstname and lastname then
  member.realname = firstname.." "..lastname
end

-- Check user nin
local nin = param.get("nin")
if nin then
  if #nin  ~= 16 then
    slot.put_into("error", _"This National Insurance Number is invalid!")
    return false
  end
  member.nin = string.upper(nin)
  member_data.nin = string.upper(nin)
else
  if not member.nin then
    slot.put_into("error", _"User NIN cannot be empty!")
    return false
  end
end

--[[
  Sensitive data 
--]]

-- Check user token serial number
local token_serial = param.get("token_serial")
if token_serial then
  if #token_serial >=8 then
    member_data.token_serial = token_serial
    member.identification = token_serial
  else
    slot.put_into("error", _"User token serial number is too short!")
    return false
  end
else
  if not member_data.token_serial then
    slot.put_into("error", _"User token serial number cannot be empty!")
    return false
  end
end

-- Check user birthplace
local birthplace = param.get("birthplace")
if birthplace then
  if #birthplace >=2 then
    member_data.birthplace = birthplace
  else
    slot.put_into("error", _"User birthplace is too short!")
    return false
  end
else
  if not member_data.birthplace then
    slot.put_into("error", _"User birthplace cannot be empty!")
    return false
  end
end

local year=param.get("birthyear",atom.integer)
local month=param.get("birthmonth",atom.integer)
local day=param.get("birthday",atom.integer)

local birthdate = atom.date:new{year=year, month=month, day=day}
if birthdate and year >1900 and day <=31 and month <=12 then
  member_data.birthdate = birthdate
else
  slot.put_into("error", _"Birthdate is invalid!")
  return false
end

-- Check user id card number
local idcard = param.get("idcard")
if idcard then
  if #idcard >=4 then
    member_data.idcard = idcard
  else
    slot.put_into("error", _"User id card number is too short!")
    return false
  end
else
  if not member_data.idcard then
    slot.put_into("error", _"User id card number cannot be empty!")
    return false
  end
end

-- Check user e-mail address
local email = param.get("email")
if email then
  if #email >=6 then
    member_data.email = email
    member.notify_email_unconfirmed = email
  else
    slot.put_into("error", _"User e-mail address is too short!")
    return false
  end
else
  if not member_data.email then
    slot.put_into("error", _"User e-mail address cannot be empty!")
    return false
  end
end

-- Check user residence data
local residence_address = param.get("residence_address")
member_data.residence_address = residence_address
local residence_city = param.get("residence_city")
member_data.residence_city = residence_city
local residence_province = param.get("residence_province")
member_data.residence_province = residence_province
local residence_postcode = param.get("residence_postcode")
member_data.residence_postcode = residence_postcode

if #residence_address < 6 or #residence_city < 2 or #residence_province == 0 or #residence_postcode < 4 then
    slot.put_into("error", _"User residence data missing or incomplete!")
    return false
end

-- Check user domicile data
local domicile_address = param.get("domicile_address")
member_data.domicile_address = domicile_address
local domicile_city = param.get("domicile_city")
member_data.domicile_city = domicile_city
local domicile_province = param.get("domicile_province")
member_data.domicile_province = domicile_province
local domicile_postcode = param.get("domicile_postcode")
member_data.domicile_postcode = domicile_postcode

if #domicile_address < 6 or #domicile_city < 2 or #domicile_province ==0 or #domicile_postcode < 4 then
    slot.put_into("error", _"User domicile data missing or incomplete!")
    return false
end

-- Check user location

local region = param.get("regions")
local province = param.get("provinces")
local city = param.get("cities")

if region and province and city and #region >= 2 and #province >=2 and #city>=2 then
 member_data.location=region.." "..province.." "..city
else
  slot.put_into("error", _"Region/Province/City data are incomplete!")
  return false
end

-- Saving
local merr = member:try_save()
if merr then
  slot.put_into("error", (_("Error while updating member, database reported:<br /><br /> (#{errormessage})"):gsub("#{errormessage}", tostring(merr.message))))
  return false
end

member_data.id = member.id

local mderr = member_data:try_save()
if mderr then
  slot.put_into("error", (_("Error while updating member sensitive data, database reported:<br /><br /> (#{errormessage})"):gsub("#{errormessage}", tostring(mderr.message))))
  return false
end

local units = Unit:new_selector():add_field("privilege.member_id NOTNULL", "privilege_exists"):add_field("privilege.voting_right", "voting_right"):left_join("privilege", nil, { "privilege.member_id = ? AND privilege.unit_id = unit.id", member.id }):exec()

for i, unit in ipairs(units) do
    local value = param.get("unit_" .. unit.id, atom.boolean)
    if value and not unit.privilege_exists then
        privilege = Privilege:new()
        privilege.unit_id = unit.id
        privilege.member_id = member.id
        privilege.voting_right = true
        privilege:save()
    elseif not value and unit.privilege_exists then
        local privilege = Privilege:by_pk(unit.id, member.id)
        privilege:destroy()
    end
end

member:send_invitation()

if id then
  slot.put_into("notice", _"Member successfully updated")
else
  slot.put_into("notice", _"Member successfully registered")
end
