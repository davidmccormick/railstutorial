namespace :db do
  desc "Fill the database with sample data"
  task populate: :environment do
  	 puts "Creating user: Example User [example@railstutorial.org]"
    User.create(name: "Example User",
                          email: "example@railstutorial.org",
                          password: "foobar",
                          password_confirmation: "foobar",
                        )
    puts "Creating user: Dave McCormick [a@b.com]"
    me = User.create(name: "Dave McCormick",
                          email: "a@b.com",
                          password: "123456",
                          password_confirmation: "123456",
                        )
    me.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = Faker::Internet.email(name)
      password = "123456"
      puts "Creating user: #{name} [#{email}]"
      User.create!(name: name, email: email, password: password, password_confirmation: password)
    end
    # create some fake microposts
    users = User.all(limit: 6)
    #turn off created_at timestamps...
    Micropost.record_timestamps = false
    users.each { |user|
    		puts "Creating microposts for:  #{user.name}"
    		posted = Time.now
    		50.times do
    			mpost = user.microposts.build(content: Faker::Lorem.sentence(5))
    			mpost.created_at = posted
    			mpost.updated_at = posted
    			mpost.save
    			# the next post will be up to 1 day OLDER than the last!
    			posted = posted - rand(86400).seconds
    		end
    }
  end
end
