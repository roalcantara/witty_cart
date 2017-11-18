unless User.find_by(email: "admin@witty-cart.io").present?
  puts "SETTING UP DEFAULT ADMIN USER LOGIN"
  user = User.new name: "Admin",
                  email: "admin@witty-cart.io",
                  password: ENV['ADMIN_PASSWORD'],
                  password_confirmation: ENV['ADMIN_PASSWORD'],
                  admin: true
  user.save
  puts "Admin User `#{user.first_name}` has been created!"
end
