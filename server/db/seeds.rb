# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Generates services
[
  { name: "Funko"}
].each do |service_params|
  service = Service.new(service_params)
  if service.save
    puts "service created: #{service.name}"
  else
    puts service.errors.inspect
  end
end

# # Generates users
service = Service.find_by_name("Funko")
[
  {
    name: "Tanjiro",
    email: "tanjiro@funko.com",
    password: "tanjirofunko",
    service_id: service.id
  },
  {
    name: "Inosuke",
    email: "inosuke@funko.com",
    password: "inosukefunko",
    service_id: service.id
  },
  {
    name: "Zenitsu",
    email: "zenitsu@funko.com",
    password: "zenitsufunko",
    service_id: service.id
  }
].each do |user_params|
  user = User.new(user_params)
  if user.save
    puts "user created: #{user.name}"
  else
    puts user.errors.inspect
  end
end

# Generates workshifts pending
workshifts_count = 0
50.times.each do
  (19..23).each do |hour|
    day = rand(10..30)
    workshift = Workshift.new(
      {
        timestamp: DateTime.new(2022,4,day,hour,0),
        service_id: service.id,
        user_id: User.pluck(:id).sample,
        status: :accepted
      }
    )
  
    if workshift.save
      workshifts_count += 1
    else
      puts workshift.errors.inspect
    end
  end
end

puts "workshifts created: #{workshifts_count}"


