module ApplicationHelper
	def is_active?(req)
		params[:controller] == req ? "class=\"active\"".html_safe : ""
	end
end
