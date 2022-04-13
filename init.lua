minetest.register_chatcommand("chpw", {
  description = "Change your password",
  privs = {interact=true},
  func = function(name, param)
	if not minetest.get_player_by_name(name) then return false, "You're not in game" end --msg for irc users
	minetest.show_formspec(name,'password_changer','size[4,4.1]field[0.3,0.5;4,1;oldpwd;Old password:;]field[0.3,1.7;4,1;newpwd1;New Password:;]field[0.3,2.9;4,1;newpwd2;Retype New Password:;]button[1,3.5;2,1;confirm;Confirm]')
end})

minetest.register_on_player_receive_fields(function(player, formname, fields)
if formname == "password_changer" then
local function pname()
	return player:get_player_name()
end
local function dcm(msg)
	minetest.chat_send_player(pname(),minetest.colorize('#FF0',msg))
end
if fields.confirm then
	local checkold = minetest.check_password_entry(pname(), minetest.get_auth_handler().get_auth(pname()).password, fields.oldpwd)
	if not checkold then
	dcm('-!- Invalid old password!')
	return end

if #fields.newpwd1 < 3 then
	dcm("-!- New password is too short! Minimum length - 3 characters.")
	return end
if #fields.newpwd1 > 24 then
	dcm("-!- New password is too long! Maximum length - 24 characters.")
	return end
if fields.newpwd1:find("[^a-zA-Z0-9%-_]") then
	dcm("-!- New password contains prohibited characters! Use only Latin letters or numbers.")
	return end

if fields.newpwd1 ~= fields.newpwd2 then
	dcm('-!- New passwords not matches!')
else
	local hash = minetest.get_password_hash(pname(), fields.newpwd2)
	minetest.set_player_password(pname(), hash)
	minetest.close_formspec(pname(), formname)
	dcm('-!- Password changed successfully, new password: '..fields.newpwd2)
end
end
end
end)
