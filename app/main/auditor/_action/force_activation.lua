local id = param.get_id()
local member = Member:by_id(id)

if app.session.member and (app.session.member.auditor or app.session.member.admin) then

if member.notify_email_unconfirmed ~= "" then
	member.notify_email = member.notify_email_unconfirmed
	member.notify_email_unconfirmed = ""
end
	member.locked = false
	member.lqfb_access = true
	member.active = true
	member.activated = db:query("SELECT now()","object")[1]
	member.last_activity = db:query("SELECT now()","object")[1]
	
	local failed = member:try_save()
	if not failed then
		slot.put_into("notice", _"Account activation forced on.")
		local subject = config.mail_subject_prefix .. " " .. _"- Account activation"
		local content = slot.use_temporary(function()
		    slot.put(_"Hello\n\n")
		    slot.put(_"You're account has been activated by your auditor.")
		    slot.put(_"Have a nice day.\n\nParelon Team\n\n")
		  end)

		local success = net.send_mail{
		  envelope_from = config.mail_envelope_from,
		  from          = config.mail_from,
		  reply_to      = config.mail_reply_to,
		  to            = member.notify_email,
		  subject       = subject,
		  content_type  = "text/plain; charset=UTF-8",
		  content       = content
		}
		return success
	else
		slot.put_into("error", _"Unable to force account activation on.")
		return false
	end

else
	slot.put_into("error", _"You don't have required permissions. Try to login again.")
	return false
end
