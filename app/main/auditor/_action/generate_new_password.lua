local id = param.get_id()
local member = Member:by_id(id)

local new_password = multirand.string( 24, "23456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz" )

member:set_password(new_password)
member:save()

	local subject = config.mail_subject_prefix .. _"new password"
  local content = slot.use_temporary(function()
      slot.put(_"Hello\n\n")
      slot.put(_"You're new password is :\n\n<strong>"..new_password.."</strong> for ")
      slot.put(request.get_absolute_baseurl() .. "index/login\n\n")
      slot.put(_"Remember to change it as soon as possible.\n\nHave a nice day.\n\nParelon Team\n\n")
    end)

  local success = net.send_mail{
    envelope_from = config.mail_envelope_from,
    from          = config.mail_from,
    reply_to      = config.mail_reply_to,
    to            = member.notify_email or member.notify_email_unconfirmed,
    subject       = subject,
    content_type  = "text/plain; charset=UTF-8",
    content       = content
  }
  return success
