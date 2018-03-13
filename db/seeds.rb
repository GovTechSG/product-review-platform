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
industry_names = [
  "Agriculture",
  "Building & Construction",
  "Food & Beverages",
  "IT",
  "Landscape",
  "Logistics",
  "Manufacturing & Engineering",
  "Maritime",
  "Media",
  "Retail Distributors",
  "Services",
  "Tourism",
  "Other"
]
industry_description = [
  "The agricultural industry, which includes enterprises engaged in growing crops, raising fish and animals, and logging wood, encompasses farms, dairies, hatcheries, and ranches.",
  "The Building & Construtction industry, heavy civil or heavy engineering that includes large public works, dams, bridges, highways, railways, water or wastewater and utility distribution.",
  "The F&B industry can be broadly defined as the process of preparing, presenting and serving of food and beverages to the customers.",
  "The IT industry, application of computers to store, retrieve, transmit and manipulate data, or information, often in the context of a business or other enterprise.",
  "The landscaping industry includes companies that care for and maintain landscapes for residences, and areas around residential complexes and business establishments.",
  "The logistics industry comprises establishments primarily engaged in transporting and warehousing goods as well as providing logistics services.",
  "The Manufacturing & Engineering industry include enterprises which handle the process of adding value to raw materials by turning them into products: electrical goods, vehicles, aircraft, food, beverages, medical supplies, pharmaceuticals, and so on.",
  "The Maritime industry includes all enterprises engaged in the business of designing, constructing, manufacturing, acquiring, operating, supplying, repairing and/or maintaining vessels, or component parts thereof: of managing and/or operating shipping lines, and customs brokerage services, shipyards, dry docks, marine railways, Marine fishing, repair shops, shipping and freight forwarding services and similar enterprises.",
  "The Media industry consists of film, print, radio, and television. These segments include movies, TV shows, radio shows, news, music, newspapers, magazines, and books.",
  "The Retail Distributors industry involves the process of selling consumer goods or Services to customers through multiple channels of distribution to earn a profit.",
  "The Services industry involve the provision of services to businesses as well as final consumers. Such services include accounting, tradesmanship (like mechanic or plumber services), computer services, restaurants, tourism, etc.",
  "The Tourism industry is the total of all businesses that directly provide goods or services to facilitate business, pleasure and leisure activities away from the home environment.",
  "Any other industry."
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
  { name: "Ministry Of Communications And Information", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Culture, Community And Youth", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Defence", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Education", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Finance", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Foreign Affairs", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Health", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Home Affairs", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Law", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Manpower", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of National Development", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Social And Family Development", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of The Environment And Water Resources", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Trade And Industry", email: "agency_@u.com", number: "34434543" },
  { name: "Ministry Of Transport", email: "agency_@u.com", number: "34434543" },
  { name: "Prime Minister'S Office", email: "agency_@u.com", number: "34434543" },
  { name: "Accounting And Corporate Regulatory Authority", email: "agency_@u.com", number: "34434543" },
  { name: "Agency For Science, Technology And Research", email: "agency_@u.com", number: "34434543" },
  { name: "Agri-Food & Veterinary Authority Of Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Board Of Architects", email: "agency_@u.com", number: "34434543" },
  { name: "Building And Construction Authority", email: "agency_@u.com", number: "34434543" },
  { name: "Casino Regulatory Authority Of Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Central Provident Fund Board", email: "agency_@u.com", number: "34434543" },
  { name: "Civil Aviation Authority Of Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Civil Service College", email: "agency_@u.com", number: "34434543" },
  { name: "Competition Commission Of Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Council For Estate Agencies", email: "agency_@u.com", number: "34434543" },
  { name: "Defence Science And Technology Agency", email: "agency_@u.com", number: "34434543" },
  { name: "Economic Development Board", email: "agency_@u.com", number: "34434543" },
  { name: "Energy Market Authority", email: "agency_@u.com", number: "34434543" },
  { name: "Government Technology Agency", email: "agency_@u.com", number: "34434543" },
  { name: "Health Promotion Board", email: "agency_@u.com", number: "34434543" },
  { name: "Health Sciences Authority", email: "agency_@u.com", number: "34434543" },
  { name: "Hotels Licensing Board", email: "agency_@u.com", number: "34434543" },
  { name: "Housing & Development Board", email: "agency_@u.com", number: "34434543" },
  { name: "Info-Communications Media Development Authority", email: "agency_@u.com", number: "34434543" },
  { name: "Inland Revenue Authority Of Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Institute Of Technical Education", email: "agency_@u.com", number: "34434543" },
  { name: "Intellectual Property Office Of Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "International Enterprise Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Iseas-Yusof Ishak Institute", email: "agency_@u.com", number: "34434543" },
  { name: "Jtc Corporation", email: "agency_@u.com", number: "34434543" },
  { name: "Land Transport Authority", email: "agency_@u.com", number: "34434543" },
  { name: "Majlis Ugama Islam, Singapura", email: "agency_@u.com", number: "34434543" },
  { name: "Maritime And Port Authority Of Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Monetary Authority Of Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Nanyang Polytechnic", email: "agency_@u.com", number: "34434543" },
  { name: "National Arts Council", email: "agency_@u.com", number: "34434543" },
  { name: "National Council Of Social Service", email: "agency_@u.com", number: "34434543" },
  { name: "National Environment Agency", email: "agency_@u.com", number: "34434543" },
  { name: "National Heritage Board", email: "agency_@u.com", number: "34434543" },
  { name: "National Library Board", email: "agency_@u.com", number: "34434543" },
  { name: "National Parks Board", email: "agency_@u.com", number: "34434543" },
  { name: "Ngee Ann Polytechnic", email: "agency_@u.com", number: "34434543" },
  { name: "People'S Association", email: "agency_@u.com", number: "34434543" },
  { name: "Professional Engineers Board, Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Pub, Singapore'S National Water Agency", email: "agency_@u.com", number: "34434543" },
  { name: "Public Transport Council", email: "agency_@u.com", number: "34434543" },
  { name: "Republic Polytechnic", email: "agency_@u.com", number: "34434543" },
  { name: "Science Centre Board", email: "agency_@u.com", number: "34434543" },
  { name: "Sentosa Development Corporation", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Accountancy Commission", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Corporation Of Rehabilitative Enterprises", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Dental Council", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Examinations And Assessment Board", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Labour Foundation", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Land Authority", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Medical Council", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Nursing Board", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Pharmacy Council", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Polytechnic", email: "agency_@u.com", number: "34434543" },
  { name: "Singapore Tourism Board", email: "agency_@u.com", number: "34434543" },
  { name: "Skillsfuture Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Sport Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Spring Singapore", email: "agency_@u.com", number: "34434543" },
  { name: "Tcm Practitioners Board", email: "agency_@u.com", number: "34434543" },
  { name: "Temasek Polytechnic", email: "agency_@u.com", number: "34434543" },
  { name: "Tote Board", email: "agency_@u.com", number: "34434543" },
  { name: "Urban Redevelopment Authority", email: "agency_@u.com", number: "34434543" },
  { name: "Workforce Singapore", email: "agency_@u.com", number: "34434543" }
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
  agency = Agency.create!(agency)
  Grants.each do |grant_hash|
    grants = grant_hash.with_indifferent_access
    if grants.key?(agency[:name])
      grantsList = grants[agency[:name]]
      grantsList.each do |grant|
        agency.grants.create!(grant)
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
  c.industries.create!(name: industry_names[i-1], description: industry_description[i-1])
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
  p.reviews.create!(score: 4, content: lorem_ipsum, reviewer_id: 1, reviewer_type: "Company", grant_id: 1, strengths: ["Empathetic", "Quality Tools & Materials", "Skilful & Knowledgeable"])
  p.reviews.create!(score: 1, content: lorem_ipsum, reviewer_id: 2, reviewer_type: "Company", grant_id: 2, strengths: ["Explanation of Project and Resources", "Skilful & Knowledgeable"])
  p.reviews.create!(score: 3, content: lorem_ipsum, reviewer_id: 3, reviewer_type: "Company", grant_id: 3, strengths: ["Reliable", "Explanation of Project and Resources", "Responsive to Messages"])
  p.reviews.create!(score: 3, content: lorem_ipsum, reviewer_id: 4, reviewer_type: "Company", grant_id: 4, strengths: ["Empathetic", "Skilful & Knowledgeable", "Responsive to Messages"])
  p.reviews.create!(score: 4, content: lorem_ipsum, reviewer_id: 5, reviewer_type: "Company", grant_id: 5, strengths: ["Reliable", "Responsive to Messages"])
  p.reviews.create!(score: 5, content: lorem_ipsum, reviewer_id: 6, reviewer_type: "Company", grant_id: 6, strengths: ["Explanation of Project and Resources", "Skilful & Knowledgeable"])
end

Service.all.each do |s|
  s.reviews.create!(score: 4, content: lorem_ipsum, reviewer_id: 1, reviewer_type: "Company", grant_id: 1, strengths: ["Reliable", "Responsive to Messages"])
  s.reviews.create!(score: 2, content: lorem_ipsum, reviewer_id: 4, reviewer_type: "Company", grant_id: 2, strengths: ["Empathetic", "Skilful & Knowledgeable", "Responsive to Messages"])
  s.reviews.create!(score: 5, content: lorem_ipsum, reviewer_id: 5, reviewer_type: "Company", grant_id: 3, strengths: ["Empathetic", "Quality Tools & Materials", "Skilful & Knowledgeable"])
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