module UsersHelper
	def gravatar_for(user,options={ size: 75 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?r=xpg&d=identicon&s=#{options[:size]}"
		image_tag(gravatar_url, alt: user.name, class: 'gravatar')
	end
end
