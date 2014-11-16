slot.put_into("notice", "This function hasn't been implemented yet. Please wait or contact the admin.")
request.redirect {
	module = "auditor",
	view = "procedures",
	id = param.get_id()
}
