# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


# Create users
User.create!(
    name: "John",
    last_name: "Doe",
    telephone: "1234567890",
    email: "john@example.com",
    password: "password",
    role: "normal"
  )
  
  User.create!(
    name: "Jane",
    last_name: "Smith",
    telephone: "9876543210",
    email: "jane@example.com",
    password: "password",
    role: "executive"
  )

  User.create!(
    name: "Milena",
    last_name: "Yapur",
    telephone: "94454632",
    email: "milena@example.com",
    password: "password",
    role: "executive"
  )
  
  User.create!(
    name: "Admin",
    last_name: "User",
    telephone: "1111111111",
    email: "admin@example.com",
    password: "password",
    role: "admin"
  )
  
  User.create!(
    name: "Supervisor",
    last_name: "User",
    telephone: "2222222222",
    email: "supervisor@example.com",
    password: "password",
    role: "supervisor"
  )

  # Create tickets
  Ticket.create!(
    title: "Bug Fix",
    priority: "low",
    description: "Fix the critical bug in the system",
    tags: "bug, fix",
    state: "open",
    normal_user_id: 1,
    executive_user_id: 2
  )

  Ticket.create!(
    title: "Feature Request",
    priority: "high",
    description: "Add a new feature to improve user experience",
    tags: "feature, request",
    state: "open",
    normal_user_id: 1,
    executive_user_id: 2,
    term_at: Date.today - 3.days
  )
  
  Ticket.create!(
    title: "Feature Request",
    priority: "high",
    description: "Add a new feature to improve user experience",
    tags: "feature, request",
    state: "open",
    normal_user_id: 1,
    executive_user_id: 2
  )
  
  # Create comments
  Comment.create!(
    body: "I'm experiencing this bug too. It needs to be fixed urgently.",
    ticket_id: 1,
    user_id: 1
  )
  
  Comment.create!(
    body: "Thanks for reporting. We'll prioritize this issue.",
    ticket_id: 1,
    user_id: 2
  )
  
  Comment.create!(
    body: "I would love to see this feature implemented!",
    ticket_id: 2,
    user_id: 1
  )
  
  Comment.create!(
    body: "We'll consider your request. Thank you for the feedback.",
    ticket_id: 2,
    user_id: 2
  )