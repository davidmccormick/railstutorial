# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: 'foobar', password_confirmation: 'foobar' ) }
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }

  it { should be_valid }
  it { should_not be_admin }
  
  describe "with the admin attribute set to true" do
  	before { @user.toggle!(:admin) }
  	it { should be_admin }
  end
  
  describe "when a name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end
  
  describe "when a name is too long" do
  	before { @user.name = "*" * 51 }
  	it { should_not be_valid }
  end
  
  describe "when an email is not present" do
  	before {
  		@user.name = "Example User"
  		@user.email = " "
  	}
  	it { should_not be_valid }
  end
  
  describe "when an email format is invalid" do
  	it "should be invalid" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+bax.com]
 			addresses.each do |address|
 				@user.email = address
 				@user.should_not be_valid
 			end
 		end
 	end
 	
 	  describe "when an email format is valid" do
  	it "should be valid" do
  		addresses = %w[user@FOO.com A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
 			addresses.each do |address|
 				@user.email = address
 				@user.should be_valid
 			end
 		end
 	end
 	
 	describe "when an email is is already taken" do
  	before {
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	}

  	it { should_not be_valid }
  end
  
  describe "when password is not present" do
  	before { @user.password = @user.password_confirmation = " " }
  	it { should_not be_valid }
  end
  
  describe "when password and password_confirmation do not match" do
  	before { @user.password_confirmation = "notmatched" }
  	it { should_not be_valid }
  end
 				
 	describe "when the password_confirmation is nil" do
 		before { @user.password_confirmation = nil }
 		it { should_not be_valid }
 	end
 
 	describe "return value of the authenticate method" do
 		before { @user.save }
 		let(:found_user) { User.find_by_email(@user.email) }
 		
 		describe "with valid password" do
 			it { should == found_user.authenticate(@user.password) }
 		end
 		
 		describe "with an invalid password" do
 			let(:user_invalid_password) { found_user.authenticate("invalidpassword") }
 			it { should_not == user_invalid_password }
 			it "unathenticated user should be nil" do
 				user_invalid_password.should be_false
 			end
 		end
 	end
 
 	describe "check remembver token is not empty when saving" do
 		before { @user.save }
 		its(:remember_token) { should_not be_blank }
 	end
 		
 	describe "micropost associations" do
 		before { @user.save }
 		
 		let!(:older_micropost) do
 			FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
 		end
 		
 	 	let!(:newer_micropost) do
 			FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
 		end	
 		
 		it "should have the right microposts in the right order" do
 			@user.microposts.should == [ newer_micropost, older_micropost ]
 		end
 		
 		it "should destroy associated microposts" do
 			microposts = @user.microposts
 			@user.destroy
 			microposts.each do |micropost|
 				Micropost.find_by_id(micropost.id).should be_nil
 			end
 		end
 	end
end
  
