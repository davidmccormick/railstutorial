require 'spec_helper'

describe "Authentication" do
	subject { page}
	describe "#signin page" do
		before { visit signin_path }
		
		it "has css \"title\" with text \"Sign in\"" do
			expect(page).to have_selector('h1', text: "Sign in")
			expect(page).to have_selector('title', text: "Sign in")
		end
	end
	
	describe "when signing in" do
		before { visit signin_path }
		
		context "with invalid credentials" do
			before { click_button "Sign in" }
		
			it "we get redirected and an error flash" do
				expect(page).to have_selector('title', text: 'Sign in')
				expect(page).to have_selector('div.alert.alert-error', text: 'Invalid')
			end
			
			describe "then visiting another page" do
				before { click_link 'Home' }
				
				it "doesn't have an error flash" do
					expect(page).to_not have_selector('div.alert.alert-error')
				end
			end
		end
		
		context "with valid credentials" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
			end
			
			it "has right content and links" do
				expect(page).to have_selector('title', text: user.name)
				expect(page).to have_link('Profile', href: user_path(user))
				expect(page).to have_link('Settings', href: edit_user_path(user))
				expect(page).to have_link('Sign out', href: signout_path)
				expect(page).to_not have_link('Sign in', href: signin_path)
			end
	
			describe "then if we sign out" do
				before { click_link ('Sign out') }
				
				it "has the right links" do
					expect(page).to have_link('Sign in')
					expect(page).to_not have_link('Profile')
					expect(page).to_not have_link('Settings')
					expect(page).to_not have_link('Sign out')
				end
			end
		end
	end
	
	describe "Authorization" do
		context "with non-signed in users" do
			let(:user) { FactoryGirl.create(:user) }
			
			describe "In the users controller" do
				describe "when visiting the edit page" do
					before { visit edit_user_path(user) }
					it "is the Sign In page" do
						expect(page).to have_selector('title', text: "Sign in")
					end
				end
				
				describe "when submitting the update action" do
					before { put user_path(user) }
					it "redirects you to the Sign In page" do
						 expect(response).to redirect_to(signin_path)
					end
				end
				
				describe "when visiting the user index" do
					before { visit users_path }
					
					it "it is the Sign in page" do
						expect(page).to have_selector('title', text: 'Sign in')
					end
				end
				
				describe "visiting the following page" do
					before { visit following_user_path(user) }
					it "redirects you to the Sign In page" do
						expect(page).to have_selector('title', text: 'Sign in')
					end
				end
				
				describe "visiting the followers page" do
					before { visit followers_user_path(user) }
					it "redirects you to the Sign In page" do
						expect(page).to have_selector('title', text: 'Sign in')
					end
				end
				
				describe "in the Relationship controller" do
					describe "submitting to the create action" do
						before { post relationships_path }
						specify { response.should redirect_to(signin_path) }
					end
					
					describe "submitting the destroy action" do
						before { delete relationship_path(1) }
						specify { response.should redirect_to(signin_path) }
					end
				end
			end
		end
		
		context "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			
			before { sign_in user }
			
			describe "visiting Users#edit page" do
				before { visit edit_user_path(wrong_user) }
				it "is not the edit page" do
					expect(page).to_not have_selector('title', text: full_title('Edit user'))
				end
			end
			
			describe "submitting a put request to the users#update action" do
				before { put user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_path) }
			end
		end
		
		describe "when attempting to visit a protected page" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				visit edit_user_path(user)
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
			end
		
			describe "after signing in" do
				
				it "should render the desired protected page" do
					expect(page).to have_selector('title', text: 'Edit user')
				end
			end
		end
			
		describe "microposts controller" do
			context "when not signed in" do
				describe "posting to create" do
					before {  post microposts_path }
					specify { expect(response).to redirect_to(signin_path) }
				end
				
				describe "deleting to destroy" do
					before { 
						micropost = FactoryGirl.create(:micropost)
						delete micropost_path(micropost)
					}
					
					it { expect(response).to redirect_to(signin_path) }

				end
			end
		end
	end	
end
