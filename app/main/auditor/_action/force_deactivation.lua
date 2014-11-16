local id = param.get_id()
local member = Member:by_id(id)

if app.session.member and (app.session.member.auditor or app.session.member.admin) then

if member.activated then
	member.locked = true
	member.lqfb_access = false
	local failed = member:try_save()
	if not failed then
		slot.put_into("notice", _"Account de-activation forced on.")
		local subject = config.mail_subject_prefix .. " " .. _"- Account de-activation"
		local content = slot.use_temporary(function()
		    slot.put(_"Hello\n\n")
		    slot.put(_"You're account has been de-activated by your auditor.")
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
		slot.put_into("error", _"Unable to force account de-activation on.")
		return false
	end
end

else
	slot.put_into("error", _"You don't have required permissions. Try to login again.")
	return false
end
