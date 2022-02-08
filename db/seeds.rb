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

kw1 = Keyword.create({ name: 'морской бой', results_count: 0 })
kw2 = Keyword.create({ name: 'настольная игра', results_count: 0 })
kw3 = Keyword.create({ name: 'семейная игра', results_count: 0 })
kw4 = Keyword.create({ name: 'пирамидка', results_count: 0 })
kw5 = Keyword.create({ name: 'пирамидка детская', results_count: 0 })
kw6 = Keyword.create({ name: 'стаканчики', results_count: 0 })
kw7 = Keyword.create({ name: 'развивающие игрушки', results_count: 0 })
kw8 = Keyword.create({ name: 'игрушка', results_count: 0 })
kw9 = Keyword.create({ name: 'русское лото', results_count: 0 })
kw10 = Keyword.create({ name: 'звуковой плакат', results_count: 0 })
kw11 = Keyword.create({ name: 'говорящая азбука', results_count: 0 })

i1 = Item.create({ name: 'Морской бой', sku: '8210228', description: 'Настольная игра "Морской бой"', user_id: u1.id })
i1.keywords << kw1
i1.keywords << kw2
i1.keywords << kw3
i2 = Item.create({ name: 'Пирамидка детская большая', sku: '9862999', description: 'Пирамидка детская большая / Стаканчики / Развивающие игрушки / Игрушки для ванной / Игрушки в песочницу', user_id: u1.id })
i2.keywords << kw4
i2.keywords << kw5
i2.keywords << kw6
i2.keywords << kw7
i2.keywords << kw8
i3 = Item.create({ name: 'Русское лото', sku: '10270819', description: 'Русское лото / Настольная игра, в компании / деревянное / Настольная игра для всей семьи', user_id: u1.id })
i3.keywords << kw2
i3.keywords << kw9
i4 = Item.create({ name: 'Звуковой плакат. Говорящая азбука', sku: '5174541', description: '', user_id: u1.id })
i4.keywords << kw10
i4.keywords << kw11
