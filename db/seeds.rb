# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

r1 = Role.create({ name: 'User', description: 'Can create items and add keywords' })
r2 = Role.create({ name: 'Moderator', description: 'Can read, update and delete items for all users' })
r3 = Role.create({ name: 'Admin', description: 'Can all' })

u1 = User.create({ fio: 'admin', email: 'use4all@mail.ru', password: '7550055', password_confirmation: '7550055', role_id: r3.id })
u2 = User.create({ fio: 'user1', email: 'test@test.ru', password: '7550055', password_confirmation: '7550055', role_id: r1.id })