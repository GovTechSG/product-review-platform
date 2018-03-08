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

Agencies = [
  { name: "Ministry Of Communications And Information", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Culture, Community And Youth", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Defence", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Education", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Finance", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Foreign Affairs", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Health", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Home Affairs", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Law", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Manpower", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of National Development", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Social And Family Development", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of The Environment And Water Resources", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Trade And Industry", email: "user_@u.com", number: "34434543" },
  { name: "Ministry Of Transport", email: "user_@u.com", number: "34434543" },
  { name: "Prime Minister'S Office", email: "user_@u.com", number: "34434543" },
  { name: "Accounting And Corporate Regulatory Authority", email: "user_@u.com", number: "34434543" },
  { name: "Agency For Science, Technology And Research", email: "user_@u.com", number: "34434543" },
  { name: "Agri-Food & Veterinary Authority Of Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Board Of Architects", email: "user_@u.com", number: "34434543" },
  { name: "Building And Construction Authority", email: "user_@u.com", number: "34434543" },
  { name: "Casino Regulatory Authority Of Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Central Provident Fund Board", email: "user_@u.com", number: "34434543" },
  { name: "Civil Aviation Authority Of Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Civil Service College", email: "user_@u.com", number: "34434543" },
  { name: "Competition Commission Of Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Council For Estate Agencies", email: "user_@u.com", number: "34434543" },
  { name: "Defence Science And Technology Agency", email: "user_@u.com", number: "34434543" },
  { name: "Economic Development Board", email: "user_@u.com", number: "34434543" },
  { name: "Energy Market Authority", email: "user_@u.com", number: "34434543" },
  { name: "Government Technology Agency", email: "user_@u.com", number: "34434543" },
  { name: "Health Promotion Board", email: "user_@u.com", number: "34434543" },
  { name: "Health Sciences Authority", email: "user_@u.com", number: "34434543" },
  { name: "Hotels Licensing Board", email: "user_@u.com", number: "34434543" },
  { name: "Housing & Development Board", email: "user_@u.com", number: "34434543" },
  { name: "Info-Communications Media Development Authority", email: "user_@u.com", number: "34434543" },
  { name: "Inland Revenue Authority Of Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Institute Of Technical Education", email: "user_@u.com", number: "34434543" },
  { name: "Intellectual Property Office Of Singapore", email: "user_@u.com", number: "34434543" },
  { name: "International Enterprise Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Iseas-Yusof Ishak Institute", email: "user_@u.com", number: "34434543" },
  { name: "Jtc Corporation", email: "user_@u.com", number: "34434543" },
  { name: "Land Transport Authority", email: "user_@u.com", number: "34434543" },
  { name: "Majlis Ugama Islam, Singapura", email: "user_@u.com", number: "34434543" },
  { name: "Maritime And Port Authority Of Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Monetary Authority Of Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Nanyang Polytechnic", email: "user_@u.com", number: "34434543" },
  { name: "National Arts Council", email: "user_@u.com", number: "34434543" },
  { name: "National Council Of Social Service", email: "user_@u.com", number: "34434543" },
  { name: "National Environment Agency", email: "user_@u.com", number: "34434543" },
  { name: "National Heritage Board", email: "user_@u.com", number: "34434543" },
  { name: "National Library Board", email: "user_@u.com", number: "34434543" },
  { name: "National Parks Board", email: "user_@u.com", number: "34434543" },
  { name: "Ngee Ann Polytechnic", email: "user_@u.com", number: "34434543" },
  { name: "People'S Association", email: "user_@u.com", number: "34434543" },
  { name: "Professional Engineers Board, Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Pub, Singapore'S National Water Agency", email: "user_@u.com", number: "34434543" },
  { name: "Public Transport Council", email: "user_@u.com", number: "34434543" },
  { name: "Republic Polytechnic", email: "user_@u.com", number: "34434543" },
  { name: "Science Centre Board", email: "user_@u.com", number: "34434543" },
  { name: "Sentosa Development Corporation", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Accountancy Commission", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Corporation Of Rehabilitative Enterprises", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Dental Council", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Examinations And Assessment Board", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Labour Foundation", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Land Authority", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Medical Council", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Nursing Board", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Pharmacy Council", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Polytechnic", email: "user_@u.com", number: "34434543" },
  { name: "Singapore Tourism Board", email: "user_@u.com", number: "34434543" },
  { name: "Skillsfuture Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Sport Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Spring Singapore", email: "user_@u.com", number: "34434543" },
  { name: "Tcm Practitioners Board", email: "user_@u.com", number: "34434543" },
  { name: "Temasek Polytechnic", email: "user_@u.com", number: "34434543" },
  { name: "Tote Board", email: "user_@u.com", number: "34434543" },
  { name: "Urban Redevelopment Authority", email: "user_@u.com", number: "34434543" },
  { name: "Workforce Singapore", email: "user_@u.com", number: "34434543" }
]

Grants = [
  { "Agency For Science, Technology And Research": [ 
    { name: "Operation & Technology Roadmapping", acronym: "OTR", description: "Want to maximise returns from your investments in technology? Get a grant for expert help from A*STAR to create a technology roadmap." },
    { name: "Technology for Enterprise Capability Upgrading", acronym: "T-UP", description: "Access the pool of talent from A*STAR’s Research Institutes and build in-house R&D capabilities in your business operations." }
  ]},
  { "Building And Construction Authority": [ 
    { name: "Building Information Model Fund", acronym: "BIM", description: "Apply for up to S$30,000 funding to build up your company's BIM collaboration capability to improve productivity in managing building projects." },
    { name: "Mechanisation Credit Scheme", acronym: "MechC", description: "Raise builders’ construction productivity through technology adoption." },
    { name: "Productivity Innovation Project Scheme", acronym: "PIP", description: "Operate your business more efficiently by re-engineering your work processes and adopting labour-efficient technologies." },
    { name: "Workforce Training & Upgrading", acronym: "WTU", description: "Get funding support when you apply for training courses and assessment offered by the BCA Academy or any Approved Training and Testing Centres (ATTCs) by the Building and Construction Authority (BCA)." }
  ]},
  { "Housing & Development Board": [ 
    { name: "Revitalisation of Shops Scheme", acronym: "ROS", description: "Supports efforts across Merchant Associations (MAs) to enhance vibrancy and competitiveness among HDB retailers." }
  ]},
  { "Info-Communications Media Development Authority": [ 
    { name: "Critical Infocomm Technology Resource Programme Plus", acronym: "CITREP+", description: "To build a strong core of specialised Singaporean ICT professionals with Smart Nation capabilities, CITREP+ is now expanded to support entry-level professionals to build specialised ICT skills through broad-based training and certifications." },
    { name: "Marketing Assistance", acronym: "", description: "Helps media companies market their productions to their target audience and grow overseas demand for Singapore-produced content." },
    { name: "Talent Assistance", acronym: "TA", description: "Helps media professionals to upgrade, upskill and secure work attachment opportunities." }
  ]},
  { "International Enterprise Singapore": [ 
    { name: "Global Company Partnership Grant", acronym: "GCP", description: "GCP Grant is International Enterprise (IE) Singapore’s programme designed to help take your business global by providing assistance in the areas of building internal capabilities, manpower development and gaining market access." },
    { name: "International Marketing Activities Programme", acronym: "iMAP", description: "iMAP supports companies who want to access overseas business opportunities through participating in tradeshows and missions organised by Trade Associations and Chambers of Commerce." },
    { name: "Market Access Incubation Programme", acronym: "MAIP", description: "The Market Access Incubation Programme (MAIP) supports startups who want to access overseas markets and networks." },
    { name: "Market Readiness Assistance Grant", acronym: "MRA", description: "Designed to accelerate the international expansion of Singapore SMEs, the Market Readiness Assistance Grant supports pre-determined activities focused on helping you in overseas set-ups, identification of business partners and overseas market promotion." }
  ]},
  { "Maritime And Port Authority Of Singapore": [
    { name: "Training@Maritime Singapore", acronym: "", description: "Upgrade knowledge and expertise of local maritime personnel through attending approved training programmes under the Maritime Cluster Fund (MCF)." }
  ]},
  { "Ministry Of Manpower": [ 
    { name: "WorkPro", acronym: "WorkPro", description: "Encourage employers to implement progressive employment practices to benefit Singaporeans through job redesign, age management practices and flexible work arrangements." }
  ]},
  { "National Environment Agency": [ 
    { name: "Energy Efficiency Fund", acronym: "E2F", description: "This grant supports industrial companies in their efforts to lower their facility's operating costs through energy efficiency." }
  ]},
  { "Singapore Tourism Board": [ 
    { name: "Business Improvement Fund", acronym: "BIF", description: "Improve your business’ productivity and competitiveness and get up to 70% funding support." },
    { name: "Training Industry Professionals In Tourism", acronym: "TIP-iT", description: "Is your business in the tourism industry? Get a grant to send your staff for upgrading as well as talent and leadership development." }
  ]},
  { "Skillsfuture Singapore": [ 
    { name: "Enhanced Training Support for SMEs", acronym: "", description: "Enhanced Training Support for SMEs is a scheme aimed at encouraging small and medium enterprises (SMEs) to send employees for training and skills upgrading." },
    { name: "Enterprise Training Support", acronym: "ETS", description: "The Enterprise Training Support scheme encourages businesses to implement progressive and innovative human resource systems that would help raise the skills and productivity of employees." }
  ]},
  { "Spring Singapore": [ 
    { name: "Automation Support Package", acronym: "ASP", description: "Reduce manpower reliance and improve productivity by embarking on large-scale automation projects." },
    { name: "Capability Development Grant", acronym: "CDG", description: "Grow your business locally and globally across development areas such as innovation, brand development and service excellence." },
    { name: "Innovation & Capability Voucher", acronym: "ICV", description: "Apply for a voucher valued at S$5,000 to develop your business capabilities and improve productivity through Consultancy Projects or Integrated Solutions. Information on the next CFC will be announced on SPRING website once details are confirmed. Interested consultancy service and solution providers may register their interest to be kept informed of the next CFC." },
    { name: "Land Productivity Grant", acronym: "LPG", description: "Get up to 70% of funding support for relocating some of your operations domestically or overseas, freeing up industrial land in the process." },
    { name: "SME Talent Programme", acronym: "STP", description: "Engage and attract local talent from the Institute of Technical Education (ITE), Polytechnics and Universities through student internship, sponsorships and fresh hire training." },
    { name: "Technology Adoption Programme", acronym: "TAP", description: "Helps to improve the accessibility to technology for small and medium enterprises (SMEs) to enhance their productivity and innovation." }
  ]},
  { "Workforce Singapore": [ 
    { name: "Career Support Programme", acronym: "CSP", description: "Wage support to encourage employers to hire eligible Singapore citizen Professionals, Managers, Executives and Technicians (PMETs) and tap on their experience and transferable skills." },
    { name: "Productivity-Max Programme", acronym: "P-Max", description: "The Productivity-Max (P-Max) programme helps small and medium enterprises (SMEs) better recruit and retain Professionals, Managers and Executives (PMEs)." }
  ]}
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

Agencies.each do |agency|
  user = User.create!(agency)
  Grants.each do |grant_hash|
    grants = grant_hash.with_indifferent_access
    if grants.key?(agency[:name])
      grantsList = grants[agency[:name]]
      grantsList.each do |grant|
        user.grants.create!(grant)
      end
    end
  end
end


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
  p.reviews.create!(score: 4, content: lorem_ipsum, company_id: 11, grant_id: 1, strengths: ["Empathetic", "Quality Tools & Materials", "Skilful & Knowledgeable"])
  p.reviews.create!(score: 1, content: lorem_ipsum, company_id: 12, grant_id: 2, strengths: ["Explanation of Project and Resources", "Skilful & Knowledgeable"])
  p.reviews.create!(score: 3, content: lorem_ipsum, company_id: 13, grant_id: 3, strengths: ["Reliable", "Explanation of Project and Resources", "Responsive to Messages"])
  p.reviews.create!(score: 3, content: lorem_ipsum, company_id: 14, grant_id: 4, strengths: ["Empathetic", "Skilful & Knowledgeable", "Responsive to Messages"])
  p.reviews.create!(score: 4, content: lorem_ipsum, company_id: 15, grant_id: 5, strengths: ["Reliable", "Responsive to Messages"])
  p.reviews.create!(score: 5, content: lorem_ipsum, company_id: 16, grant_id: 6, strengths: ["Explanation of Project and Resources", "Skilful & Knowledgeable"])
end

Service.all.each do |s|
  s.reviews.create!(score: 4, content: lorem_ipsum, company_id: 11, grant_id: 7, strengths: ["Reliable", "Responsive to Messages"])
  s.reviews.create!(score: 2, content: lorem_ipsum, company_id: 14, grant_id: 8, strengths: ["Empathetic", "Skilful & Knowledgeable", "Responsive to Messages"])
  s.reviews.create!(score: 5, content: lorem_ipsum, company_id: 15, grant_id: 9, strengths: ["Empathetic", "Quality Tools & Materials", "Skilful & Knowledgeable"])
end

Review.all.each_with_index do |r, i|
  r.comments.create!(content: lorem_ipsum, user_id: 1)
  r.comments.create!(content: lorem_ipsum, user_id: 2)
  r.comments.create!(content: lorem_ipsum, user_id: 3)
  r.comments.create!(content: lorem_ipsum, user_id: 2)
  r.comments.create!(content: lorem_ipsum, user_id: 4)
  r.comments.create!(content: lorem_ipsum, user_id: 5)

  r.likes.create!(user_id: 1)
  r.likes.create!(user_id: 2)
  r.likes.create!(user_id: 3)
  r.likes.create!(user_id: 4)
  r.likes.create!(user_id: 5)
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if (Rails.env.development? || Rails.env.test?)