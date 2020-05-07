# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             superior: false,
             admin: true)


User.create!(name: "上長A",
             email: "sampleA@email.com",
             password: "password",
             password_confirmation: "password",
             superior: true,
             admin: false)
             
User.create!(name: "上長B",
             email: "sampleB@email.com",
             password: "password",
             password_confirmation: "password",
             superior: true,
             admin: false)
 
User.create!(name: "上長C",
             email: "sampleC@email.com",
             password: "password",
             password_confirmation: "password",
             superior: true,
             admin: false)            

             
60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
               
               
               
end