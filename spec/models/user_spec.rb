require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'devise modules' do
    it 'includes database_authenticatable module' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable module' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable module' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable module' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable module' do
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe 'authentication' do
    let(:user) { create(:user, password: 'password123') }

    it 'authenticates with valid password' do
      expect(user.valid_password?('password123')).to be true
    end

    it 'does not authenticate with invalid password' do
      expect(user.valid_password?('wrongpassword')).to be false
    end
  end

  describe 'factory' do
    it 'creates a valid user' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'creates unique emails for multiple users' do
      user1 = create(:user)
      user2 = create(:user)

      expect(user1.email).not_to eq user2.email
    end
  end
end
