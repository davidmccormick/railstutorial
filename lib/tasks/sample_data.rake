namespace :db do
  desc "Fill the database with sample data"
  task populate: :environment do
    User.create(name: "Example User",
                          email: "example@railstutorial.org",
                          password: "foobar",
                          password_confirmation: "foobar",
                        )
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
  end
end
