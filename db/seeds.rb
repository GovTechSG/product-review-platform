# For demo purposes
App.create!(name: "BGP", password: "test12", password_confirmation: "test12")
company_names = [
  "Pivotal Software",
  "Microsoft",
  "Oracle",
  "SAP",
  "salesforce.com",
  "ThoughtWorks",
  "ADP",
  "Zendesk",
  "Hubspot",
  "RingCentral"
]
UENs = [
  "984208875",
  "984208874",
  "984208873",
  "984208872",
  "584208374",
  "384208875",
  "284208874",
  "484208873",
  "844208872",
  "574208374",
]

lorem_ipsum = "Vestibulum nec turpis vestibulum, feugiat mi at, egestas ex. Proin non enim mollis lacus pulvinar laoreet et quis augue. Nam nec magna at leo ultrices auctor. Ut interdum a neque eget malesuada. Phasellus vel velit pulvinar tellus cursus pharetra vehicula in lectus. Nulla viverra erat sed viverra viverra. Aliquam at condimentum nisl, eget ornare turpis. Nulla sollicitudin efficitur tortor at imperdiet."
10.times do |i|
  Company.create!(name: company_names[i], UEN: UENs[i], aggregate_score: 4.2, description: lorem_ipsum)
end
# c_1.products.create!(name: "Step2 Children's Chair", description: "A great chair for your child!")
# c_1.products.create!(name: "Rachio Router", description: "The best router for your money")
# c_1.products.create!(name: "ChengXinTu Hiking Backpack", description: "Get ready to summit Mount Everest.")
# c_1.services.create!(name: "Pivotal Car Mechanics", description: "Lowest prices all around")
# c_1.services.create!(name: "Greenplum Hand Washers", description: "Cleanest hands")
# c_1.services.create!(name: "Carpenters R'Us", description: "Got a fixer-upper? Look no further!")

User.create!(name: "MTI", email: "agency_1@foo.com", number: "51512234")
User.create!(name: "IES", email: "agency_2@foo.com", number: "51512236")
User.create!(name: "SPRING Singapore", email: "agency_3@foo.com", number: "71512234")
User.create!(name: "EDB", email: "agency_4@foo.com", number: "51512235")
User.create!(name: "IMDA", email: "agency_5@foo.com", number: "51512237")

(1..10).each do |i|
  c = Company.find(i)
  c.products.create!(name: "PivotalTracker", description: lorem_ipsum)
  c.products.create!(name: "Cloud Foundry", description: lorem_ipsum)
  c.products.create!(name: "Greenplum", description: lorem_ipsum)
  c.services.create!(name: "Spring Framework", description: lorem_ipsum)
  c.services.create!(name: "Agile Development", description: lorem_ipsum)
end

SMEs = [
  "Grab",
  "Carousell",
  "Ninja Van",
  "Redmart",
  "ShopBack",
  "Shopee",
  "SEA"
]

SME_UENs = [
  "332244643",
  "332244633",
  "332254643",
  "632244643",
  "442244643",
  "447244643",
  "447212643"
]

7.times do |i|
  Company.create!(name: SMEs[i], UEN: SME_UENs[i], aggregate_score: 4.2, description: lorem_ipsum)
end

Product.all.each do |p|
  p.reviews.create!(score: 4, content: lorem_ipsum, company_id: 11, strengths: ["Empathetic", "Quality Tools & Materials", "Skilful & Knowledgeable"])
  p.reviews.create!(score: 1, content: lorem_ipsum, company_id: 12, strengths: ["Explanation of Project and Resources", "Skilful & Knowledgeable"])
  p.reviews.create!(score: 3, content: lorem_ipsum, company_id: 13, strengths: ["Reliable", "Explanation of Project and Resources", "Responsive to Messages"])
  p.reviews.create!(score: 3, content: lorem_ipsum, company_id: 14, strengths: ["Empathetic", "Skilful & Knowledgeable", "Responsive to Messages"])
  p.reviews.create!(score: 4, content: lorem_ipsum, company_id: 15, strengths: ["Reliable", "Responsive to Messages"])
  p.reviews.create!(score: 5, content: lorem_ipsum, company_id: 16, strengths: ["Explanation of Project and Resources", "Skilful & Knowledgeable"])
end

Service.all.each do |s|
  s.reviews.create!(score: 4, content: lorem_ipsum, company_id: 11, strengths: ["Reliable", "Responsive to Messages"])
  s.reviews.create!(score: 2, content: lorem_ipsum, company_id: 14, strengths: ["Empathetic", "Skilful & Knowledgeable", "Responsive to Messages"])
  s.reviews.create!(score: 5, content: lorem_ipsum, company_id: 15, strengths: ["Empathetic", "Quality Tools & Materials", "Skilful & Knowledgeable"])
end

Review.all.each_with_index do |r, i|
  r.comments.create!(content: lorem_ipsum, agency_id: 1)
  r.comments.create!(content: lorem_ipsum, agency_id: 2)
  r.comments.create!(content: lorem_ipsum, agency_id: 3)
  r.comments.create!(content: lorem_ipsum, agency_id: 2)
  r.comments.create!(content: lorem_ipsum, agency_id: 4)
  r.comments.create!(content: lorem_ipsum, agency_id: 5)

  r.likes.create!(agency_id: 1)
  r.likes.create!(agency_id: 2)
  r.likes.create!(agency_id: 3)
  r.likes.create!(agency_id: 4)
  r.likes.create!(agency_id: 5)
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if (Rails.env.development? || Rails.env.test?)