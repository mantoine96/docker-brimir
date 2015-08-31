#!/bin/ruby
u = User.new({email:'test@test.com', password:'password', password_confirmation:'password'});
u.agent=true;
u.save!
