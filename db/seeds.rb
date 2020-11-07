# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

OrderItem.destroy_all
Item.destroy_all
Order.destroy_all
User.destroy_all
Merchant.destroy_all

#merchants
bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
print_shop = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

#bike_shop items
tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", active: true, inventory: 12)
dark_helmet = bike_shop.items.create!(name: "Dark Helmet", description: "It'll never break!", price: 15, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", active: true, inventory: 15)
light_helmet = bike_shop.items.create!(name: "Light Helmet", description: "It's a light helmet!", price: 20, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", active: true, inventory: 17)
blue_helmet = bike_shop.items.create!(name: "Blue Helmet", description: "It's a blue helmet", price: 15, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", active: true, inventory: 22)

#dog_shop items
pull_toy = dog_shop.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", active: true, inventory: 32)
dog_bone = dog_shop.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active: true, inventory: 21)
squeaky_toy = dog_shop.items.create!(name: "Squeaky Toy", description: "They'll love it!", price: 25, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active: true, inventory: 42)
chew_toy = dog_shop.items.create!(name: "Chew Toy", description: "They'll love it!", price: 11, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active: true, inventory: 15)
rope = dog_shop.items.create!(name: "Rope", description: "They'll love it!", price: 13, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active: true, inventory: 25)

#print_shop items
paper = print_shop.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", active: true, inventory: 25)
pencil = print_shop.items.create!(name: "Pencil", description: "Great for writing with!", price: 30, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", active: true, inventory: 2000)

#users
user1 = User.create!({name: "Connorname",
                     address: "Connoraddress",
                     city: "Connorcity",
                     state: "Connorstate",
                     zip: "Connorzip",
                     email: "Connor@email.com",
                     password: "Connorpass",
                     password_confirmation: "Connorpass",
                     role: 0})

user2 = bike_shop.users.create!({name: "Bobname",
                                address: "Bobaddress",
                                city: "Bobcity",
                                state: "Bobstate",
                                zip: "Bobzip",
                                email: "Bob@email.com",
                                password: "Bobpass",
                                password_confirmation: "Bobpass",
                                role: 1})

user3 = dog_shop.users.create!({name: "Eugenename",
                               address: "Eugeneaddress",
                               city: "Eugenecity",
                               state: "Eugenestate",
                               zip: "Eugenezip",
                               email: "Eugene@email.com",
                               password: "Eugenepass",
                               password_confirmation: "Eugenepass",
                               role: 1})

user4 = User.create!({name: "Jessename",
                     address: "Jesseaddress",
                     city: "Jessecity",
                     state: "Jessestate",
                     zip: "Jessezip",
                     email: "Jesseemail",
                     password: "Jessepass",
                     password_confirmation: "Jessepass",
                     role: 2})

#orders
user1_order1 = user1.orders.create!(status: 0)
user2_order1 = user2.orders.create!(status: 0)
user3_order1 = user3.orders.create!(status: 0)
user3_order2 = user3.orders.create!(status: 0)

user1_order1.order_items.create!(item_id: tire.id, quantity: 5, price: tire.price, fulfilled: false)
user1_order1.order_items.create!(item_id: pull_toy.id, quantity: 10, price: pull_toy.price, fulfilled: false)

user2_order1.order_items.create!(item_id: pull_toy.id, quantity: 20, price: pull_toy.price, fulfilled: false)

user3_order1.order_items.create!(item_id: pencil.id, quantity: 50, price: pencil.price, fulfilled: false)

user3_order2.order_items.create!(item_id: pencil.id, quantity: 100, price: pencil.price, fulfilled: false)
user3_order2.order_items.create!(item_id: dark_helmet.id, quantity: 1, price: dark_helmet.price, fulfilled: false)
