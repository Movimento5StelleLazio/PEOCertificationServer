slot.set_layout("custom")
local id = param.get_id()
local member = Member:by_id(id)
local member_data = MemberData:by_id(id)

if member and member.certifier_id ~= app.session.member_id then
  slot.put_into("error", _"This user was not certified by you!")
  return false
end

ui.script{static = "js/jquery.validate.js" }

local confirm_box1 = param.get("confirm_box1",atom.boolean)
local confirm_box2 = param.get("confirm_box2",atom.boolean)
local confirm_box3 = param.get("confirm_box3",atom.boolean)
--local confirm_box4 = param.get("confirm_box4",atom.boolean)
local confirm_box5 = param.get("confirm_box5",atom.boolean)
local confirm_box6 = param.get("confirm_box6",atom.boolean)
local confirm_box7 = param.get("confirm_box7",atom.boolean)

if ( not member or not member_data ) and 
  (confirm_box1 ~= true or 
   confirm_box2 ~= true or 
   confirm_box3 ~= true or 
   --confirm_box4 ~= true or 
   confirm_box5 ~= true or 
   confirm_box6 ~= true or
   confirm_box7 ~= true ) then


  if confirm_box1 == true or
     confirm_box2 == true or
     confirm_box3 == true or
     --confirm_box4 == true or
     confirm_box5 == true or
     confirm_box6 == true or
     confirm_box7 == true then
    slot.put_into("error", _"Devi confermare tutte le clausole per continuare")
  end

  ui.container{ attr = { class = "row-fluid" }, content = function()
    ui.container{ attr = { class = "span12 well" }, content = function()
      ui.container{ attr = { class = "row-fluid" }, content = function()
        ui.container{ attr = { class = "span3 text-center" }, content = function()
          ui.link{
            attr = { class="btn btn-primary btn-large fixclick"  },
            module = "auditor",
            view = "index",
            content = function()
              ui.heading{level=5,attr={class=""},content=function()
                ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
                slot.put(_"Back")
              end }
            end
          }
        end }
        ui.container{ attr = { class = "span9 text-center" }, content = function()
          ui.heading{ level = 1, attr = { class = "uppercase"  }, content = _"Auditor Panel".." ID:"..app.session.member_id }
          ui.heading{ level = 3, attr = { class = "uppercase"  }, content = _"Dichiarazioni obbligatorie" }
        end }
      end }
    end }
  end }
  
  ui.container{ attr = { class = "row-fluid spaceline2" }, content = function()
    ui.container{ attr = { class = "span12 alert alert-simple issue_box paper"}, content = function()
      ui.form{
        attr = { class = "", role="form" },
        module = "auditor",
        view = "member_edit",
        id = member and member.id,
        readonly = not app.session.member.auditor,
        content = function()
          ui.container{ attr = { class = "row-fluid text-center spaceline2" }, content = function()
            ui.container{ attr = { class = "span12" }, content = function()
              ui.heading{ level=1, content=_("Tu #{realname}, in qualita' di certificatore per il P.E.O. attesti che il cittadino che si vuole registrare:", {realname = (#app.session.member.realname > 0 and app.session.member.realname or app.session.member.login)} )}
              ui.field.boolean{ style="radio", label_attr={class="auditor_confirm_label spaceline2"},  label = _"E' (o era) presente fisicamente insieme a te al momento della registrazione e il suo aspetto fisico corrisponde alla Foto e alla Descrizione del Documento di Identita' presentato", name = "confirm_box1" }
              ui.field.boolean{ style="radio", label_attr={class="auditor_confirm_label spaceline2"},  label = _"Dichiara di essere cittadino Italiano maggiorenne", name = "confirm_box2" }
              ui.field.boolean{ style="radio", label_attr={class="auditor_confirm_label spaceline2"},  label = _"Dichiara di essere cittadino con la residenza (indicata dal documento di identita') nella stessa regione/comune/municipio dove e'  attivo il Parlamento Elettronico Online", name = "confirm_box3" }
              --ui.field.boolean{ style="radio", label_attr={class="auditor_confirm_label spaceline2"},  label = _"Dichiara di essere utente registrato e certificato sul sito http://www.beppegrillo.it/movimento/", name = "confirm_box4" }
              ui.field.boolean{ style="radio", label_attr={class="auditor_confirm_label spaceline2"},  label = _"Dichiara di possedere l'indirizzo email che fornira' al sistema", name = "confirm_box5" }
              ui.field.boolean{ style="radio", label_attr={class="auditor_confirm_label spaceline2"},  label = _"Dichiara avere un Documento di Identita' valido", name = "confirm_box6" }
              ui.field.boolean{ style="radio", label_attr={class="auditor_confirm_label spaceline2"},  label = _"Dichiara di avere con se la Tessera del Codice Fiscale o la Tessera Sanitaria con indicato il CF", name = "confirm_box7" }
              ui.tag{
                tag="button",
                attr = { type="submit", class="btn btn-primary btn-large fixclick spaceline3" },
                content= function()
                  ui.heading{ level=4, attr = { class="inline-block"}, content= _"Confirm"}
                end
              }
            end }
          end }
        end
      }
    end }
  end }
  return false
end


ui.container{ attr = { class = "row-fluid" }, content = function()
  ui.container{ attr = { class = "span12 well" }, content = function()
    ui.container{ attr = { class = "row-fluid" }, content = function()
      ui.container{ attr = { class = "span3 text-center" }, content = function()
        ui.link{
          attr = { class="btn btn-primary btn-large fixclick"  },
          module = "auditor",
          view = "index",
          content = function()
            ui.heading{level=5,attr={class=""},content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
              slot.put(_"Back")
            end }
          end
        }       
      end }
      ui.container{ attr = { class = "span9 text-center" }, content = function()
        ui.heading{ level = 1, attr = { class = "uppercase"  }, content = _"Auditor Panel".." ID:"..app.session.member_id }
        ui.heading{ level = 3, attr = { class = ""  }, content = function()
          if member then
            slot.put(_("Edit member: #{firstname} #{lastname}", { firstname = member.firstname, lastname = member.lastname }))
            slot.put(" (Id:"..member.id..")") 
          else
            slot.put(_"Register new member")
          end
        end }
      end }
    end }
  end }
end }

ui.container{ attr = { class = "row-fluid spaceline2" }, content = function()
  ui.container{ attr = { class = "span12 alert alert-simple issue_box paper"}, content = function()
    ui.form{
      module = "auditor",
      attr={id="member-form", class="form-horizontal"},
      action = "member_update",
      id = member and member.id,
      readonly = not app.session.member.auditor,
      routing = {
        ok = {
          mode = "redirect",
          modules = "auditor",
          view = "index"
        }
      },
      content = function()

        ui.field.hidden{name="confirm_box1", value=confirm_box1 or false}
        ui.field.hidden{name="confirm_box2", value=confirm_box2 or false}
        ui.field.hidden{name="confirm_box3", value=confirm_box3 or false}
        --ui.field.hidden{name="confirm_box4", value=confirm_box4 or false}
        ui.field.hidden{name="confirm_box5", value=confirm_box5 or false}
        ui.field.hidden{name="confirm_box6", value=confirm_box6 or false}
        ui.field.hidden{name="confirm_box7", value=confirm_box7 or false}

        ui.heading{ level = 2, attr = { class = "text-center"  }, content = _"Personal data" }
        --ui.container{ attr = { class = "text-center uppercase"  }, legend=_"Personal data", content=function()

        ui.field.text{ 
          record = member,
          --label_attr={class="control-label auditor_input_label"},
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Name"},
          label=_"Name", 
          name = "firstname",
          value = param.get("firstname") 
        }
        ui.field.text{ 
          record = member,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Surname"}, 
          label = _"Surname", 
          name = "lastname",
          value = param.get("lastname") 
        }
        ui.field.text{ 
          record = member,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",maxlength="16",placeholder=_"NIN"}, 
          label = _"NIN", 
          name = "nin", 
          value = param.get("nin") 
        }
        ui.field.text{ 
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder="email@example.org"}, 
          label = _"Email", 
          name = "email", 
          value = param.get("email")
        }
        ui.field.text{ 
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"City"}, 
          label = _"Birthplace", 
          name = "birthplace", 
          value = param.get("birthplace")
        }
        ui.field.text{
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input", maxlength="4", placeholder=_"yyyy"},
          label = _"Year of birth",
          name = "birthyear",
          value = param.get("birthyear",atom.integer) or (member_data and member_data.birthdate.year)
        }
        ui.field.text{
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input", maxlength="2", placeholder=_"mm"},
          label = _"Month of birth",
          name = "birthmonth",
          value = param.get("birthmonth",atom.integer) or (member_data and member_data.birthdate.month)
        }
        ui.field.text{
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input", maxlength="2", placeholder=_"dd"},
          label = _"Day of birth",
          name = "birthday",
          value = param.get("birthday",atom.integer) or (member_data and member_data.birthdate.day)
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"ID card number"},
          label = _"ID card number",
          name = "idcard",
          value = param.get("idcard")
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Token Serial"},
          label = _"Token serial",
          name = "token_serial",
          value = param.get("token_serial")
        }
        if member then        
		      ui.field.boolean {
		      	name = "elected",
		      	label = _"Eletto",
		      	label_attr={class="auditor_input_label"},
		      	container_attr={class="control-group"},
		        attr={class="auditor_input",placeholder=_"Elected"},
		        style = "checkbox",
		        value = param.get("elected", atom.boolean) or member.elected
		      }
		    else
		    	ui.field.boolean {
		    		record = member,
		      	name = "elected",
		      	label = _"Eletto",
		      	label_attr={class="auditor_input_label"},
		      	container_attr={class="control-group"},
		        attr={class="auditor_input",placeholder=_"Elected"},
		        style = "checkbox",
		        value = param.get("elected", atom.boolean) or false
		      }
		    end
        if app.session.member.admin then
        	if member then
				    ui.field.boolean {
				    	record = member,
				    	name = "auditor",
				    	label = _"Certificatore",
				    	label_attr={class="auditor_input_label"},
				    	container_attr={class="control-group"},
				      attr={class="auditor_input",placeholder=_"Auditor"},
				      style = "checkbox",
				      value = param.get("auditor", atom.boolean) or member.auditor
				    }
				    ui.field.boolean {
				    	record = member,
				    	name = "admin",
				    	label = _"Admin",
				    	label_attr={class="auditor_input_label"},
				    	container_attr={class="control-group"},
				      attr={class="auditor_input",placeholder=_"Admin"},
				      style = "checkbox",
				      value = param.get("admin", atom.boolean) or member.admin
		      	}
				  else
				  	ui.field.boolean {
				  		name = "auditor",
				    	label = _"Certificatore",
				    	label_attr={class="auditor_input_label"},
				    	container_attr={class="control-group"},
				      attr={class="auditor_input",placeholder=_"Auditor"},
				      style = "checkbox",
				      value = param.get("auditor", atom.boolean) or false
				    }
				    ui.field.boolean {
				    	name = "admin",
				    	label = _"Admin",
				    	label_attr={class="auditor_input_label"},
				    	container_attr={class="control-group"},
				      attr={class="auditor_input",placeholder=_"Admin"},
				      style = "checkbox",
				      value = param.get("admin", atom.boolean) or false
		      	}
				  end	      
        end

        --[[ 
          Residence
        --]]
        ui.heading{ level = 2, attr = { class = "text-center  spaceline3"  }, content = _"Residence" }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Residence address", onchange="if(getElementsByName('domicile_address')[0].value == '') { getElementsByName('domicile_address')[0].value = getElementsByName('residence_address')[0].value; return; }"},
          label = _"Residence address",
          name = "residence_address",
          value = param.get("residence_address")
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Residence city", onchange="if(getElementsByName('domicile_city')[0].value == '') { getElementsByName('domicile_city')[0].value = getElementsByName('residence_city')[0].value; return; }"},
          label = _"Residence city",
          name = "residence_city",
          value = param.get("residence_city")
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Residence province", onchange="if(getElementsByName('domicile_province')[0].value == '') { getElementsByName('domicile_province')[0].value = getElementsByName('residence_province')[0].value; return; }"},
          label = _"Residence province",
          name = "residence_province",
          value = param.get("residence_province")
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Residence postcode", onchange="if(getElementsByName('domicile_postcode')[0].value == '') { getElementsByName('domicile_postcode')[0].value = getElementsByName('residence_postcode')[0].value; return; }"},
          label = _"Residence postcode",
          name = "residence_postcode",
          value = param.get("residence_postcode")
        }

        --[[ 
          Domicile
        --]]
        ui.heading{ level = 2, attr = { class = "text-center  spaceline3"  }, content = _"Domicile" }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Domicile address"},
          label = _"Domicile address",
          name = "domicile_address",
          value = param.get("domicile_address")
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Domicile city"},
          label = _"Domicile city",
          name = "domicile_city",
          value = param.get("domicile_city")
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Domicile province"},
          label = _"Domicile province",
          name = "domicile_province",
          value = param.get("domicile_province")
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          container_attr={class="control-group"},
          attr={class="auditor_input",placeholder=_"Domicile postcode"},
          label = _"Domicile postcode",
          name = "domicile_postcode",
          value = param.get("domicile_postcode")
        }        

        regions=db:query("SELECT nome_regione,codice_regione FROM istat_regioni ORDER BY nome_regione;") 
        provinces=db:query("SELECT nome_provincia,codice_provincia,codice_regione FROM istat_province ORDER BY nome_provincia;")
        cities=db:query("SELECT nome_comune,codice_provincia,codice_comune FROM istat_comuni ORDER BY nome_comune;")

        ui.script{static = "js/jquery.chained.js" }

        local location={}

        if member_data and member_data.location then
          for v in  string.gmatch(member_data.location, "[^%s]+") do
            location[#location+1] = v
          end
        end
        
        local reg = param.get("regions")
        local prov = param.get("provinces")
        local cit = param.get("cities")

        if reg and #reg == 2 then location[1] = reg end
        if prov and #prov == 3 then location[2] = prov end
        if cit and #cit == 6 then location[3] = cit end

        ui.heading{ level = 2, attr = { class = "text-center spaceline3"  }, content = _"Unit" }
        
        slot.put('<div class="control-group">')  
        slot.put('<label for="regions" class="auditor_input_label">Regione</label>')  
        slot.put('<select id ="regions" name="regions" class="auditor_input">')  
        slot.put('<option value=""></option>')  
        for k,region in ipairs(regions) do
          if region.codice_regione == location[1] then
            slot.put('<option selected value="'..region.codice_regione..'">'..region.nome_regione..'</option>')
          else
            slot.put('<option value="'..region.codice_regione..'">'..region.nome_regione..'</option>')
          end
        end
        slot.put('</select>')  
        slot.put('</div>')  

        slot.put('<div class="control-group">')
        slot.put('<label for="provinces" class="auditor_input_label">Provincia</label>')
        slot.put('<select id ="provinces" name="provinces" class="auditor_input">')
        slot.put('<option value=""></option>')  
        for k,province in ipairs(provinces) do
          if province.codice_provincia == location[2] then
            slot.put('<option selected value="'..province.codice_provincia..'" class="'..province.codice_regione..'">'..province.nome_provincia..'</option>')
          else
            slot.put('<option value="'..province.codice_provincia..'" class="'..province.codice_regione..'">'..province.nome_provincia..'</option>')
          end
        end
        slot.put('</select>')
        slot.put('</div>')
        
        slot.put('<div class="control-group">')
        slot.put('<label for="cities" class="auditor_input_label">Comune</label>')
        slot.put('<select id ="cities" name="cities" class="auditor_input">')
        slot.put('<option value=""></option>')
        for k,city in ipairs(cities) do
          if city.codice_comune == location[3] then
            slot.put('<option selected value="'..city.codice_comune..'" class="'..city.codice_provincia..'">'..city.nome_comune..'</option>')
          else
            slot.put('<option value="'..city.codice_comune..'" class="'..city.codice_provincia..'">'..city.nome_comune..'</option>')
          end
        end
        slot.put('</select>')
        slot.put('</div>')

        ui.script{script = '$("#provinces").chained("#regions");' }
        ui.script{script = '$("#cities").chained("#provinces");' }


        local units_selector
        local units

        if not param.get_id() then
            -- Create new privileges: the new member inherits them from the auditor
            units_selector = app.session.member.units
            units = Unit:get_flattened_tree{} --units_selector:exec()
            ui.list {
                        records = units,
                        columns = {
                              {
                                    field_attr = { style = "font-weight:bold;font-size:22px;"},
                                  content = function(unit)
                                      for i = 1, unit.depth - 1 do
                                          slot.put("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
                                      end
                                      local style = ""
                                      if not unit.active then
                                          style = "text-decoration: line-through;"
                                      end
                                      ui.link {
                                            name = "unit_" .. unit.id,
                                            text = unit.name
                                      }
                                  end
                              },
                              {
                                    content = function(unit)
                                            ui.field.boolean {
                                                name = "unit_" .. unit.id,
                                                  --label = unit.name,
                                                  value = app.session.member:has_voting_right_for_unit_id(unit.id)
                                              }
                                    end
                              }
                        }
                }
        else
            units_selector = Unit:new_selector()
            units = Unit:get_flattened_tree{} --units_selector:exec()
            ui.list {
                        records = units,
                        columns = {
                              {
                                    field_attr = { style = "font-weight:bold;font-size:22px;"},
                                  content = function(unit)
                                      for i = 1, unit.depth - 1 do
                                          slot.put("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
                                      end
                                      local style = ""
                                      if not unit.active then
                                          style = "text-decoration: line-through;"
                                      end
                                      ui.link {
                                            name = "unit_" .. unit.id,
                                            text = unit.name
                                      }
                                  end
                              },
                              {
                                    content = function(unit)
                                            ui.field.boolean {
                                            name = "unit_" .. unit.id,
                                                  --label = unit.name,
                                                  value = member:has_voting_right_for_unit_id(unit.id)
                                              }
                                    end
                              }
                        }
                }
        end



        ui.container{ attr = { class = "row-fluid text-center spaceline2" }, content = function()
          ui.container{ attr = { class = "span6 offset3" }, content = function()
            ui.tag{
              tag="button",
              attr = { type="submit", class="btn btn-primary btn-large" },
              content= function()
                ui.heading{ level=4, attr = { class="inline-block"}, content= _"Save"}
              end
            }
          end }
        end }

        ui.script{static="js/jquery.validate_memeber_edit.js"}

      end
    }
  end }
end }
