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
  "RingCentral",
  "Redmart",
  "ShopBack",
  "Shopee",
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
  "Retail",
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
  "The Retail industry involves the process of selling consumer goods or Services to customers through multiple channels of distribution to earn a profit.",
  "The Services industry involve the provision of services to businesses as well as final consumers. Such services include accounting, tradesmanship (like mechanic or plumber services), computer services, restaurants, tourism, etc.",
  "The Tourism industry is the total of all businesses that directly provide goods or services to facilitate business, pleasure and leisure activities away from the home environment.",
  "Any other industry."
]
uens = [
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
  "632244643",
  "442244643",
  "447244643",
]

Strengths = [
  { name: "Reliability", description: "The ability to deliver the promised product or service in a consistent and accurate manner." },
  { name: "Explanation of Project and Resources", description: "The project and resources is definite, distinct, and clearly explained" },
  { name: "Responsiveness", description: "Respond quickly and consistently to private messages" },
  { name: "Quality Tools & Materials", description: "Delivers quality product/service" },
  { name: "Skills & Knowledge", description: "Knowledge of business needs and skills to produce solution based on knowledge" },
  { name: "Understanding Business Needs", description: "Understands business perspective and has good domain knowledge" },
  { name: "Communication", description: "The ability to communicate well" },
  { name: "Deliverables", description: "The ability to deliver what is promised" }
]

Agencies = [
  { name: "Ministry Of Communications And Information", email: "MCI_Connects@mci.gov.sg", phone_number: "1800-8379655", acronym: "MCI", kind: "Ministry", description: "The Ministry of Communications and Information (MCI) oversees the development of the infocomm technology, cyber security, media and design sectors; the national library, national archives and public libraries; as well as Government’s information and public communication policies. MCI’s mission is to connect our people to community, government and opportunity, enabled by trustworthy infrastructure and technology." },
  { name: "Ministry Of Culture, Community And Youth", email: "", phone_number: "6338 3632", acronym: "MCCY", kind: "Ministry", description: "The Ministry of Culture, Community and Youth (MCCY) seeks to inspire Singaporeans through the arts and sports, deepen a sense of identity and belonging to the nation, strengthen community bonds, engage youths and promote volunteerism and philanthropy, to build a gracious and caring society we are proud to call home." },
  { name: "Ministry Of Defence", email: "MINDEF_Feedback_Unit@defence.gov.sg", phone_number: "1800-3676767", acronym: "MINDEF", kind: "Ministry", description: "The mission of MINDEF and the Singapore Armed Forces is to enhance Singapore's peace and security through deterrence and diplomacy, and should these fail, to secure a swift and decisive victory over the aggressor." },
  { name: "Ministry Of Education", email: "contact@moe.gov.sg", phone_number: "68721110", acronym: "MOE", kind: "Ministry", description: "The Mission of the Education Service is to mould the future of the nation, by moulding the people who will determine the future of the nation. The Service will provide our children with a balanced and well-rounded education, develop them to their full potential, and nurture them into good citizens, conscious of their responsibilities to family, society and country." },
  { name: "Ministry Of Finance", email: "mof_qsm@mof.gov.sg", phone_number: "62259911", acronym: "MOF", kind: "Ministry", description: "MOF's mission is to create a better Singapore through Finance." },
  { name: "Ministry Of Foreign Affairs", email: "mfa@mfa.sg", phone_number: "1800-476-8870", acronym: "MFA", kind: "Ministry", description: "The Mission of the Foreign Ministry is to advance and safeguard the interests of Singapore and Singaporeans through effective diplomacy." },
  { name: "Ministry Of Health", email: "moh_info@moh.gov.sg", phone_number: "63259220", acronym: "MOH", kind: "Ministry", description: "The mission of the Ministry of Health is to be an innovative and people centred organisation to promote good health and reduce illness, ensure that Singaporeans have access to good and affordable health care that is appropriate to needs, and to pursue medical excellence." },
  { name: "Ministry Of Home Affairs", email: "mha_feedback@mha.gov.sg", phone_number: "64787010", acronym: "MHA", kind: "Ministry", description: "We work as a team, in partnership with the community, to make Singapore our safe and secure Best Home." },
  { name: "Ministry Of Law", email: "", phone_number: "1800 2255 529", acronym: "MINLAW", kind: "Ministry", description: "Our Mission is to advance access to justice, the rule of law, the economy and society through policy, law and services." },
  { name: "Ministry Of Manpower", email: "", phone_number: "6438 5122", acronym: "MOM", kind: "Ministry", description: "Our Mission: To develop a productive workforce and progressive workplaces, for Singaporeans to have better jobs and a secure retirement." },
  { name: "Ministry Of National Development", email: "mnd_hq@mnd.gov.sg", phone_number: "62221211", acronym: "MND", kind: "Ministry", description: "The mission of MND is to develop world-class infrastructure, create a vibrant and sustainable living environment and build rooted and cohesive communities." },
  { name: "Ministry Of Social And Family Development", email: "", phone_number: "63555000", acronym: "MSF", kind: "Ministry", description: "The Ministry of Social And Family Development Mission is: To Nurture-Resilient Individuals, Strong Families And A Caring Society." },
  { name: "Ministry Of The Environment And Water Resources", email: "mewr_feedback@mewr.gov.sg", phone_number: "67319000", acronym: "MEWR", kind: "Ministry", description: "MEWR's mission is to deliver and sustain a clean and healthy environment and water resources for all in Singapore." },
  { name: "Ministry Of Trade And Industry", email: "mti_email@mti.gov.sg", phone_number: "62259911", acronym: "MTI", kind: "Ministry", description: "Mission Statement - To promote economic growth and create good jobs, to enable Singaporeans to improve their lives" },
  { name: "Ministry Of Transport", email: "mot@mot.gov.sg", phone_number: "62707988", acronym: "MOT", kind: "Ministry", description: "To strengthen Singapore's transportation connectivity and to develop the transport sector's potential to advance our economic competitiveness and the quality of life in Singapore." },
  { name: "Prime Minister'S Office", email: "pmo_hq@pmo.gov.sg", phone_number: "62358577", acronym: "PMO", kind: "Ministry", description: "To co-ordinate the activities of Ministries and the general policies of the Government and to provide overall policy direction; to eradicate corruption and maintain readiness for elections; to co-ordinate Singapore's climate change-related policies; to guide and co-ordinate whole-of-government efforts in the implementation of national population policies and programmes; to implement national research, innovation and enterprise strategies; to strive for robust security, a networked government and a resilient Singapore; to ensure the efficient and effective management and development of public service officers through sound and progressive personnel policies in service conditions, career growth and staff training; to build capacity and capability in the Service, promote quality service and productivity; to provide secretariat support to the Public Service Commission (PSC); and to promote sustained non-inflationary economic growth, as well as foster a sound and progressive financial centre." },
  { name: "Accounting And Corporate Regulatory Authority", email: "", phone_number: "62486028", acronym: "ACRA", kind: "Statutory Board", description: "To provide a responsive and trusted regulatory environment for businesses, public accountants and corporate service providers." },
  { name: "Agency For Science, Technology And Research", email: "contact@a-star.edu.sg", phone_number: "68266111", acronym: "A*STAR", kind: "Statutory Board", description: "We advance science and develop innovative technology to further economic growth and improve lives." },
  { name: "Agri-Food & Veterinary Authority Of Singapore", email: "", phone_number: "68052992", acronym: "AVA", kind: "Statutory Board", description: "The Agri-Food & Veterinary Authority (AVA) ensures a resilient supply of safe food, safeguards the health of animals and plants, and facilitates agri-trade for the well-being of Singapore" },
  { name: "Board Of Architects", email: "boarch@singnet.com.sg", phone_number: "62225295", acronym: "BOA", kind: "Statutory Board", description: "The Board of Architects is the statutory authority established to administer the Architects Act in Singapore. The Architects Act 1991 sets out provisions to provide for the registration of architects, the regulation of architectural qualifications, the practice of architecture by registered individuals and the supply of architectural services by corporations." },
  { name: "Building And Construction Authority", email: "bca_enquiry@bca.gov.sg", phone_number: "1800-3425222", acronym: "BCA", kind: "Statutory Board", description: "Mission: We shape a safe, high quality, sustainable and friendly built environment. Vision: To have a future-ready built environment for Singapore" },
  { name: "Casino Regulatory Authority Of Singapore", email: "feedback@cra.gov.sg", phone_number: "6501 7000", acronym: "CRA", kind: "Statutory Board", description: "Ensuring that the management and operation of a casino is and remains free from criminal influence or exploitation. Ensuring that gaming in a casino is conducted honestly. Containing and controlling the potential of a casino to cause harm to minors, vulnerable persons and society at large." },
  { name: "Central Provident Fund Board", email: "", phone_number: "1800 2271188", acronym: "CPF", kind: "Statutory Board", description: "STRIVING FOR EXCELLENCE The Central Provident Fund (CPF) is a social security savings scheme jointly supported by employees, employers and the Government. Its basic purpose is to help CPF members meet primary needs like shelter, food, clothing and health services in their old age or when they are no longer able to work. Benefits offered are to help meet one or more needs of the CPF Member in his retirement. They include withdrawals by the Member for retirement, permanent disablement, home ownership and health care. The amounts available depend on how much the Member has saved in the CPF. The CPF Board are trustees for the CPF savings of Members. We aim to provide CPF Members, in a cost-effective manner, the widest range of quality services possible. We seek also to help employers pay CPF contributions promptly and correctly in as efficient and convenient a way as possible. Where we can, we make our assets and services available to help meet Singapore's social and economic objectives, thereby improving the quality of life of all Singaporeans and CPF Members." },
  { name: "Civil Aviation Authority Of Singapore", email: "qsm@caas.gov.sg", phone_number: "65421122", acronym: "CAAS", kind: "Statutory Board", description: "The Civil Aviation Authority of Singapore enables the growth of the air hub and aviation industry, oversees and promotes safety in the industry, provide air navigation services, and develop Singapore as a centre of excellence for aviation knowledge and talent development." },
  { name: "Civil Service College", email: "cscollege@cscollege.gov.sg", phone_number: "68741733", acronym: "CSC", kind: "Statutory Board", description: "The Civil Service College (CSC) was established as a statutory board under the Public Service Division in 2001. As the heart of learning for the Singapore Public Service, we deliver an innovative, inspiring and impactful learning experience for public officers." },
  { name: "Competition Commission Of Singapore", email: "CCS_feedback@ccs.gov.sg", phone_number: "1800-3258282", acronym: "CCS", kind: "Statutory Board", description: "Making markets work well to create opportunities and choices for businesses and consumers in Singapore" },
  { name: "Council For Estate Agencies", email: "feedback@cea.gov.sg", phone_number: "1800 643 2555", acronym: "CEA", kind: "Statutory Board", description: "Established under the Estate Agents Act, CEA is empowered to administer the new regulatory framework for the real estate agency industry. In addition, CEA is committed to raise the professionalism of the real estate agency industry through collaborative efforts with the industry on industry development programmes and protect the interests of the consumers through targeted public education schemes." },
  { name: "Defence Science And Technology Agency", email: "feedback@dsta.gov.sg", phone_number: "68195333", acronym: "DSTA", kind: "Statutory Board", description: "The Agency shall harness and exploit science and technology, and provide technological and engineering support, to meet the defence and national security needs of Singapore." },
  { name: "Economic Development Board", email: "clientservices@edb.gov.sg", phone_number: "68326832", acronym: "EDB", kind: "Statutory Board", description: "The Singapore Economic Development Board (EDB), a government agency under the Ministry of Trade and Industry, is responsible for strategies that enhance Singapore’s position as a global centre for business, innovation, and talent." },
  { name: "Energy Market Authority", email: "ema_enquiry@ema.gov.sg", phone_number: "68358000", acronym: "EMA", kind: "Statutory Board", description: "To Forge a Progressive Energy Landscape for Sustained Growth." },
  { name: "Government Technology Agency", email: "info@tech.gov.sg", phone_number: "6211 0888", acronym: "GOVTECH", kind: "Statutory Board", description: "At GovTech, It's not business as usual. We transform the delivery of Government digital services by taking an \"outside-in\" view, where users are at the heart of everything we do." },
  { name: "Health Promotion Board", email: "hpb_mailbox@hpb.gov.sg", phone_number: "64353500", acronym: "HPB", kind: "Statutory Board", description: "Health Promotion Board aims to build a nation of healthy people and empower the people of Singapore to take ownership of their health." },
  { name: "Health Sciences Authority", email: "", phone_number: "62130838", acronym: "HSA", kind: "Statutory Board", description: "The Health Sciences Authority is the national authority regulating health products; managing the national blood bank, transfusion medicine and forensic medicine expertise; and providing critical forensic and analytical laboratory services. With our multidisciplinary expertise, HSA aims to be the leading innovative authority, protecting and advancing national health and safety." },
  { name: "Hotels Licensing Board", email: "hlb_info@hlb.gov.sg", phone_number: "67366622", acronym: "HLB", kind: "Statutory Board", description: "Subjects Registration of Hotels, Issue and Renewal of Hotel-Keeper's Licences." },
  { name: "Housing & Development Board", email: "hdb@mailbox.hdb.gov.sg", phone_number: "64901111", acronym: "HDB", kind: "Statutory Board", description: "The Housing & Development Board (HDB) is Singapore's public housing authority. We plan and develop Singapore's housing estates; building homes and transforming towns to create a quality living environment for all. We provide various commercial, recreational, and social amenities in our towns for our residents’ convenience." },
  { name: "Info-Communications Media Development Authority", email: "", phone_number: "6377 3800", acronym: "IMDA", kind: "Statutory Board", description: "The IMDA develops and regulates the converging infocomm and media sectors in a holistic way, creating a dynamic and exciting sector filled with opportunities for growth, through an emphasis on talent, research, innovation and enterprise." },
  { name: "Inland Revenue Authority Of Singapore", email: "iras@iras.gov.sg", phone_number: "63568233", acronym: "IRAS", kind: "Statutory Board", description: "The Inland Revenue Authority of Singapore (IRAS) is the main tax administrator to the Government. IRAS collects taxes that account for about 70% of the Government's Operating Revenue that supports the Government's economic and social programmes to achieve quality growth and an inclusive society. IRAS also represents the Government in tax treaty negotiations, drafts tax legislations and provides advice on property valuation to the Government." },
  { name: "Institute Of Technical Education", email: "itehq@ite.edu.sg", phone_number: "1800-2222 111", acronym: "ITE", kind: "Statutory Board", description: "Our Mission: To create opportunities for students and adult learners to acquire skills, knowledge and values for employability and lifelong learning." },
  { name: "Intellectual Property Office Of Singapore", email: "", phone_number: "63398616", acronym: "IPOS", kind: "Statutory Board", description: "The Intellectual Property Office of Singapore (IPOS) is a statutory board under the Ministry of Law. We are an innovation agency that uses our IP expertise and networks to drive Singapore’s future growth. Our focus is on helping enterprises grow through IP and innovation strategies, developing skills and expertise in these areas, and creating a vibrant ecosystem where today’s ideas become tomorrow’s assets." },
  { name: "International Enterprise Singapore", email: "enquiry@iesingapore.gov.sg", phone_number: "63376628", acronym: "IE", kind: "Statutory Board", description: "International Enterprise (IE) Singapore is the government agency driving Singapore’s external economy. For the past 30 years, it has been spearheading the overseas growth of Singapore-based companies and promoting international trade. With its global network in over 35 locations spanning many developed and emerging markets, IE Singapore attracts global commodities traders to establish their global or Asian home base in Singapore and connects businesses with relevant Singapore-based companies for their business expansion." },
  { name: "Iseas-Yusof Ishak Institute", email: "", phone_number: "67780955", acronym: "ISEAS", kind: "Statutory Board", description: "The ISEAS-Yusof Ishak Institute is a Regional Centre dedicated to the study of Socio-Political, Security and Economic Trends and Developments in Southeast Asia and its Wider Geostrategic and Economic Environment." },
  { name: "Jtc Corporation", email: "askjtc@jtc.gov.sg", phone_number: "65600056", acronym: "JTC", kind: "Statutory Board", description: "Set up in 1968, JTC is the lead government agency responsible for the development of industrial infrastructure to support and catalyse the growth of industries and enterprises in Singapore. Landmark projects by JTC include the Jurong Industrial Estate; the Jurong Island for energy and chemical industries; business and specialised parks such as the International and Changi Business Parks, Seletar Aerospace Park and Tuas Biomedical Park; a work-live-play-&-learn development called one-north; next generation districts including Jurong Innovation District and the Punggol Digital District, as well as the Jurong Rock Caverns, Southeast Asia’s first commercial underground storage facility for liquid hydrocarbons. JTC also develops innovative space such as the JTC Surface Engineering Hub, JTC MedTech Hub, JTC Food Hub @ Senoko, and TimMac @ Kranji which incorporate innovative features and shared infrastructure and services to enable industrialists to start their operations quickly and enhance productivity." },
  { name: "Land Transport Authority", email: "", phone_number: "1800 - 2255 582", acronym: "LTA", kind: "Statutory Board", description: "The Land Transport Authority (LTA) is a statutory board under the Ministry of Transport, that spearheads land transport developments in Singapore. 'Connecting People and Places, Enhancing Travel Experience' is our mission statement." },
  { name: "Majlis Ugama Islam, Singapura", email: "info@muis.gov.sg", phone_number: "6359 1199", acronym: "MUIS", kind: "Statutory Board", description: "To work with the community in developing a profound religious life and dynamic institutions so as to build a gracious, progressive and resilient community that thrives with diversity and serves humanity." },
  { name: "Maritime And Port Authority Of Singapore", email: "qsm@mpa.gov.sg", phone_number: "63751600", acronym: "MPA", kind: "Statutory Board", description: "The Maritime and Port Authority is a statutory board under the Ministry of Transport. Our mission is to develop and promote Singapore as a premier global hub port and international maritime centre, and to advance and safeguard Singapore's strategic maritime interests. Our vision is to be a leading maritime agency driving Singapore's global maritime aspirations." },
  { name: "Monetary Authority Of Singapore", email: "webmaster@mas.gov.sg", phone_number: "62255577", acronym: "MAS", kind: "Statutory Board", description: "The Monetary Authority of Singapore is the central bank of Singapore. Our mission is to promote sustained non-inflationary economic growth, and a sound and progressive financial centre." },
  { name: "Nanyang Polytechnic", email: "askNYP@nyp.edu.sg", phone_number: "64515115", acronym: "NYP", kind: "Statutory Board", description: "Nanyang Polytechnic is committed to providing quality education and training to prepare our graduates for life and work, equipping them to contribute to the technological, economic and social development of Singapore. Nanyang Polytechnic will harness our resources and expertise to offer manpower development programmes and services to business and industry in support of Singapore's national development." },
  { name: "National Arts Council", email: "nac_feedback@nac.gov.sg", phone_number: "63469400", acronym: "NAC", kind: "Statutory Board", description: "NAC Mission : To champion the creation and appreciation of the arts as an integral part of our lives. NAC Vision : Home to diverse and distinctive arts which inspire our people, connect our communities and position Singapore globally." },
  { name: "National Council Of Social Service", email: "ncss_webmaster@ncss.gov.sg", phone_number: "6210 2500", acronym: "NCSS", kind: "Statutory Board", description: "NCSS is the umbrella body for over 450 social service organisations in Singapore. Its mission is to provide leadership and direction in enhancing the capabilities and capacity of our members, advocating for social service needs and strengthening strategic partnerships, for an effective social service ecosystem. Community Chest is the fund-raising and engagement arm of NCSS and Social Service Institute (SSI) is the human capital development arm of NCSS. For more information, please visit: www.ncss.gov.sg." },
  { name: "National Environment Agency", email: "", phone_number: "1800 2255 632", acronym: "NEA", kind: "Statutory Board", description: "An enterprising agency, embracing all in achieving a liveable and sustainable Singapore." },
  { name: "National Heritage Board", email: "nhb_feedback@nhb.gov.sg", phone_number: "63380000", acronym: "NHB", kind: "Statutory Board", description: "The National Heritage Board (NHB) is the custodian of Singapore’s heritage. We are responsible for telling the Singapore story, sharing the Singaporean experience and imparting our Singapore spirit." },
  { name: "National Library Board", email: "enquiry@nlb.gov.sg", phone_number: "63323133", acronym: "NLB", kind: "Statutory Board", description: "NLB Vision: Reader for Life, Learning Communities, Knowledgeable Nation. NLB Mission: We make knowledge come alive, spark imagination and create possibilities. " },
  { name: "National Parks Board", email: "nparks_mailbox@nparks.gov.sg", phone_number: "64717808", acronym: "NPARKS", kind: "Statutory Board", description: "VISION: Let's make Singapore our Garden MISSION: To create the best living environment through excellent greenery and recreation, in partnership with the community. The National Parks Board plans, develops and manages parks and greenery in Singapore." },
  { name: "Ngee Ann Polytechnic", email: "np_qsm@np.edu.sg", phone_number: "64666555", acronym: "NP", kind: "Statutory Board", description: "POLYTECHNICNgee Ann Polytechnic provides relevant, balanced and value-adding curriculum with an effective teaching and learning environment complete with active networking with industry and institutions. Together with our professional and motivated staff, our mission is to nurture enterprising professionals for the economy through education and training." },
  { name: "People's Association", email: "", phone_number: "6344 8222", acronym: "PA", kind: "Statutory Board", description: "The People’s Association (PA) was established on 1 July 1960 as a statutory board to promote racial harmony and social cohesion in Singapore. Our mission is to build and bridge communities in achieving one people, one Singapore. PA offers a wide range of programmes to cater to Singaporeans from all walks of life - connecting people to people, and people and government. We do this through our network of 1,800 grassroots organisations (GROs), over 100 Community Clubs, five Community Development Councils, National Community Leadership Institute and Water-Venture." },
  { name: "Professional Engineers Board, Singapore", email: "registrar@peb.gov.sg", phone_number: "63342310", acronym: "PEB", kind: "Statutory Board", description: "PEB’s Mission is to safeguard life, property, and welfare of the public by setting and maintaining high standards for registering professional engineers, and by regulating and advancing the practice of professional engineering." },
  { name: "Pub, Singapore'S National Water Agency", email: "pub_one@pub.gov.sg", phone_number: "1800-2255 782", acronym: "PUB", kind: "Statutory Board", description: "PUB is a statutory board under the Ministry of the Environment and Water Resources. It is the national water agency that manages Singapore’s water supply, water catchment and used water in an integrated way." },
  { name: "Public Transport Council", email: "ptc_office@ptc.gov.sg", phone_number: "63549020", acronym: "PTC", kind: "Statutory Board", description: "The Public Transport Council regulates public transport fares and ticket payment services, and also undertakes the role of an advisor to the Minister for Transport on public transport matters. In discharging its functions, the Council seeks to safeguard the interest of the public and ensure the long-term viability of public transport operators." },
  { name: "Republic Polytechnic", email: "one-stop@rp.edu.sg", phone_number: "65103000", acronym: "RP", kind: "Statutory Board", description: "An educational institution of choice for nurturing innovative, entrepreneurial and cultured professionals. We nurture individuals to prepare them for a dynamic world in partnership with stakeholders, leveraging on problem-based learning." },
  { name: "Science Centre Board", email: "feedback@science.edu.sg", phone_number: "64252500", acronym: "SCB", kind: "Statutory Board", description: "The Singapore Science Centre has a mission to promote interest, learning and creativity in Science and Technology through imaginative and enjoyable experience and contribute to the nation's development of its human resource." },
  { name: "Sentosa Development Corporation", email: "", phone_number: "6275 0388", acronym: "SDC", kind: "Statutory Board", description: "Our vision is Sentosa, the leader in shaping leisure and lifestyle experiences, plays an integral role in making Singapore a global city." },
  { name: "Singapore Accountancy Commission", email: "enquiries@sac.gov.sg", phone_number: "6325 0518", acronym: "SAC", kind: "Statutory Board", description: "We develop for Singapore a vibrant accountancy sector that enables the economy to grow, businesses to thrive and talent to flourish." },
  { name: "Singapore Corporation Of Rehabilitative Enterprises", email: "score_Contact_Us@score.gov.sg", phone_number: "62142801", acronym: "SCORE", kind: "Statutory Board", description: "Singapore Corporation of Rehabilitative Enterprises (SCORE) was established as a statutory board under the Ministry of Home Affairs on 1 April 1976. SCORE plays an important role in the Singapore correctional system by creating a safe and secure Singapore through the provision of rehabilitation and aftercare services to inmates and ex-offenders. SCORE seeks to enhance the employability of offenders and prepare them for their eventual reintegration into the national workforce by focusing on four main building blocks of training, work, employment assistance and community engagement" },
  { name: "Singapore Dental Council", email: "enquiries@dentalcouncil.gov.sg", phone_number: "", acronym: "SDC", kind: "Statutory Board", description: "The Singapore Dental Council is the self-regulatory body for the dental professions constituted under the Dental Registration Act (Chapter 76). Its key objectives are to promote high standards of oral health and to promote the interests of the dental profession in Singapore." },
  { name: "Singapore Examinations And Assessment Board", email: "contact@moe.gov.sg", phone_number: "6872 2220", acronym: "SEAB", kind: "Statutory Board", description: "Conduct national examinations; develop test instruments; conduct research on assessment; advise schools on test development and usage" },
  { name: "Singapore Labour Foundation", email: "general@slf.gov.sg", phone_number: "6213 8585", acronym: "SLF", kind: "Statutory Board", description: "The Singapore Labour Foundation (SLF) provides financial support to NTUC, its affiliated unions, co-operatives and associations for their educational, social, cultural and recreational activities. It also extends assistance to lower-income union members through its welfare schemes. SLF is funded mainly by contributions from unions, co-operatives, and returns from investments." },
  { name: "Singapore Land Authority", email: "sla_enquiry@sla.gov.sg", phone_number: "63239829", acronym: "SLA", kind: "Statutory Board", description: "The mission of the Singapore Land Authority is to optimise land resources for the economic and social development of Singapore. It ensures the best use of State land and buildings, provides an effective and reliable land management system and enables the full use of land information for better land management." },
  { name: "Singapore Medical Council", email: "enquiries@smc.gov.sg", phone_number: "6355 2478", acronym: "SMC", kind: "Statutory Board", description: "The Singapore Medical Council (SMC) is a statutory board under the Ministry of Health." },
  { name: "Singapore Nursing Board", email: "snb_contact@snb.gov.sg", phone_number: "64785400", acronym: "SNB", kind: "Statutory Board", description: "The Singapore Nursing Board (SNB) is the regulatory authority for nurses and midwives in Singapore. We aim to protect the public through licensure and regulation of nursing/midwifery education and practice." },
  { name: "Singapore Pharmacy Council", email: "enquiries@spc.gov.sg", phone_number: "64785068", acronym: "SPC", kind: "Statutory Board", description: "Registration of pharmacists, issue of annual practising certificates for pharmacists, investigation on pharmacist's professional misconduct, enquiries on pharmacist registration in Singapore." },
  { name: "Singapore Polytechnic", email: "contactus@sp.edu.sg", phone_number: "67751133", acronym: "SP", kind: "Statutory Board", description: "The first educational institution of its kind, Singapore Polytechnic offers 45 full-time diploma courses to prepare students for university and work." },
  { name: "Singapore Tourism Board", email: "stb_feedback@stb.gov.sg", phone_number: "6736 6622", acronym: "STB", kind: "Statutory Board", description: "The Singapore Tourism Board (STB) is the lead development agency for tourism, one of Singapore's key economic sectors. Together with industry partners and the community, we shape a dynamic Singapore tourism landscape.  We bring the Passion Made Possible brand to life by differentiating Singapore as a vibrant destination that inspires people to share and deepen their passions." },
  { name: "Skillsfuture Singapore", email: "", phone_number: "6785 5785", acronym: "SSG", kind: "Statutory Board", description: "SkillsFuture is a national movement to provide Singaporeans with the opportunities to develop their fullest potential throughout life, regardless of their starting points. Through this movement, the skills, passion and contributions of every individual will drive Singapore's next phase of development towards an advanced economy and inclusive society." },
  { name: "Sport Singapore", email: "", phone_number: "65005000", acronym: "SPORTSG", kind: "Statutory Board", description: "A statutory board of the Ministry of Culture, Community and Youth, Sport Singapore’s core purpose is to inspire the Singapore spirit and transform Singapore through sport. Through innovative, fun and meaningful sporting experiences, our mission is to reach out and serve communities across Singapore with passion and pride. With Vision 2030 – Singapore’s sports master plan – our mandate goes beyond winning medals. Sport Singapore (SportSG) uses sport to create greater sporting opportunities and access, more inclusivity and integration as well as broader development of capabilities. At SportSG, we work with a vast network of public-private-people sector partners for individuals to live better through sports." },
  { name: "Spring Singapore", email: "smeinfoline@spring.gov.sg", phone_number: "6278 6666", acronym: "SPRING", kind: "Statutory Board", description: "Main agency for enterprise development, to enhance the competitiveness of enterprises for a vibrant Singapore economy" },
  { name: "Tcm Practitioners Board", email: "Enquiries@tcmpb.gov.sg", phone_number: "6355 2488", acronym: "TCMPB", kind: "Statutory Board", description: "The Traditional Chinese Medicine Practitioners Board (TCMPB) is a statutory board established under the Traditional Chinese Medicine Practitioners Act 2000. TCMPB registers TCM practitioners (both acupuncturists and TCM physicians), accredits TCM institutions and TCM courses for the purpose of registration and regulates the professional ethics and conduct of registered TCM practitioners." },
  { name: "Temasek Polytechnic", email: "", phone_number: "67882000", acronym: "TP", kind: "Statutory Board", description: "To prepare school - leavers and working adults for a future of dynamic change, with relevant knowledge, lifelong skills, character, and a thirst for continuous improvement." },
  { name: "Tote Board", email: "toteboard_enquiries@toteboard.gov.sg", phone_number: "62168900", acronym: "TOTE-BOARD", kind: "Statutory Board", description: "We contribute towards building an inclusive, resilient and vibrant community through our grants.We ensure Singapore Pools and Singapore Turf Club conduct their gaming businesses in a socially responsible manner, and channel surpluses towards our grantmaking." },
  { name: "Urban Redevelopment Authority", email: "", phone_number: "62216666", acronym: "URA", kind: "Statutory Board", description: "The Urban Redevelopment Authority is the national planning authority of Singapore.  Our mission is to make Singapore a great city to live, work and play." },
  { name: "Workforce Singapore", email: "", phone_number: "68835885", acronym: "WSG", kind: "Statutory Board", description: "Workforce Singapore (WSG) is a statutory board under the Ministry of Manpower (MOM). It will oversee the transformation of the local workforce and industry to meet ongoing economic challenges. WSG will promote the development, competitiveness, inclusiveness, and employability of all levels of the workforce. This will ensure that all sectors of the economy are supported by a strong, inclusive Singaporean core. While its key focus is to help workers meet their career aspirations and secure quality jobs at different stages of life, WSG will also address the needs of business owners and companies by providing support to enable manpower-lean enterprises to remain competitive. It will help businesses in different economic sectors create quality jobs, develop a manpower pipeline to support industry growth, and match the right people to the right jobs." }
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
    { name: "Marketing Assistance", acronym: "MA", description: "Helps media companies market their productions to their target audience and grow overseas demand for Singapore-produced content." },
    { name: "Talent Assistance", acronym: "TA", description: "Helps media professionals to upgrade, upskill and secure work attachment opportunities." }
  ]},
  { "International Enterprise Singapore": [ 
    { name: "Global Company Partnership Grant", acronym: "GCP", description: "GCP Grant is International Enterprise (IE) Singapore’s programme designed to help take your business global by providing assistance in the areas of building internal capabilities, manpower development and gaining market access." },
    { name: "International Marketing Activities Programme", acronym: "iMAP", description: "iMAP supports companies who want to access overseas business opportunities through participating in tradeshows and missions organised by Trade Associations and Chambers of Commerce." },
    { name: "Market Access Incubation Programme", acronym: "MAIP", description: "The Market Access Incubation Programme (MAIP) supports startups who want to access overseas markets and networks." },
    { name: "Market Readiness Assistance", acronym: "MRA", description: "Designed to accelerate the international expansion of Singapore SMEs, the Market Readiness Assistance Grant supports pre-determined activities focused on helping you in overseas set-ups, identification of business partners and overseas market promotion." },
    { name: "Pre-scoped Productivity Solutions", acronym: "PSG", description: "The Productivity Solutions Grant (PSG) supports companies keen on adopting IT solutions and equipment to enhance business processes." }
  ]},
  { "Maritime And Port Authority Of Singapore": [
    { name: "Training@Maritime Singapore", acronym: "TMS", description: "Upgrade knowledge and expertise of local maritime personnel through attending approved training programmes under the Maritime Cluster Fund (MCF)." }
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
    { name: "Enhanced Training Support for SMEs", acronym: "ETS", description: "Enhanced Training Support for SMEs is a scheme aimed at encouraging small and medium enterprises (SMEs) to send employees for training and skills upgrading." },
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
13.times do |i|
  company = Company.new(name: company_names[i], uen: uens[i], aggregate_score: rand(-1..1) , description: lorem_ipsum, url: FFaker::Internet.http_url, phone_number: FFaker::PhoneNumberSG.fixed_line_number )
  company.image = File.new(company.avatar_path(200))
  company.save
end
# c_1.products.create!(name: "Step2 Children's Chair", description: "A great chair for your child!")
# c_1.products.create!(name: "Rachio Router", description: "The best router for your money")
# c_1.products.create!(name: "ChengXinTu Hiking Backpack", description: "Get ready to summit Mount Everest.")
# c_1.services.create!(name: "Pivotal Car Mechanics", description: "Lowest prices all around")
# c_1.services.create!(name: "Greenplum Hand Washers", description: "Cleanest hands")
# c_1.services.create!(name: "Carpenters R'Us", description: "Got a fixer-upper? Look no further!")

Agencies.each do |agency_param|
  agency = Agency.new(agency_param)
  agency.image = File.new(agency.avatar_path(200))
  agency.save
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


(1..13).each do |i|
  c = Company.find(i)
  c.products.create!(name: "PivotalTracker", description: lorem_ipsum)
  c.products.create!(name: "Cloud Foundry", description: lorem_ipsum)
  c.products.create!(name: "Greenplum", description: lorem_ipsum)
  c.services.create!(name: "Spring Framework", description: lorem_ipsum)
  c.services.create!(name: "Agile Development", description: lorem_ipsum)
  c.projects.create!(name: "Making Spring Framework", description: lorem_ipsum)
  c.projects.create!(name: "Making Agile Development", description: lorem_ipsum)
  c.industries.create!(name: industry_names[i-1], description: industry_description[i-1])
end

Strengths.each do |strength|
  Aspect.create!(strength)
end


Product.all.each do |p|
  p.reviews.create!(score: rand(-1..1), content: lorem_ipsum, reviewer_id: 1, reviewer_type: "Company", grant_id: 1)
  p.reviews.create!(score: rand(-1..1), content: lorem_ipsum, reviewer_id: 2, reviewer_type: "Company", grant_id: 2)
  p.reviews.create!(score: rand(-1..1), content: lorem_ipsum, reviewer_id: 3, reviewer_type: "Company", grant_id: 3)
  p.reviews.create!(score: rand(-1..1), content: lorem_ipsum, reviewer_id: 4, reviewer_type: "Company", grant_id: 4)
  p.reviews.create!(score: rand(-1..1), content: lorem_ipsum, reviewer_id: 5, reviewer_type: "Company", grant_id: 5)
  p.reviews.create!(score: rand(-1..1), content: lorem_ipsum, reviewer_id: 6, reviewer_type: "Company", grant_id: 6)
end

Service.all.each do |s|
  s.reviews.create!(score: rand(-1..1), content: lorem_ipsum, reviewer_id: 1, reviewer_type: "Company", grant_id: 1)
  s.reviews.create!(score: rand(-1..1), content: lorem_ipsum, reviewer_id: 4, reviewer_type: "Company", grant_id: 2)
  s.reviews.create!(score: rand(-1..1), content: lorem_ipsum, reviewer_id: 5, reviewer_type: "Company", grant_id: 3)
end

Review.all.each_with_index do |r, i|
  r.comments.create!(content: lorem_ipsum, commenter_id: 1, commenter_type: "Agency", commentable_id: 1, commentable_type: "Review")
  r.comments.create!(content: lorem_ipsum, commenter_id: 2, commenter_type: "Agency", commentable_id: 2, commentable_type: "Review")
  r.comments.create!(content: lorem_ipsum, commenter_id: 3, commenter_type: "Agency", commentable_id: 3, commentable_type: "Review")
  r.comments.create!(content: lorem_ipsum, commenter_id: 4, commenter_type: "Agency", commentable_id: 4, commentable_type: "Review")
  r.comments.create!(content: lorem_ipsum, commenter_id: 5, commenter_type: "Agency", commentable_id: 5, commentable_type: "Review")
  r.comments.create!(content: lorem_ipsum, commenter_id: 6, commenter_type: "Agency", commentable_id: 6, commentable_type: "Review")
  
  AspectReview.create!(aspect: Aspect.first, review: r)
  AspectReview.create!(aspect: Aspect.last, review: r)

  r.likes.create!(liker_id: 1, liker_type: "Agency", likeable_id: 1, likeable_type: "Review")
  r.likes.create!(liker_id: 2, liker_type: "Agency", likeable_id: 2, likeable_type: "Review")
  r.likes.create!(liker_id: 3, liker_type: "Agency", likeable_id: 3, likeable_type: "Review")
  r.likes.create!(liker_id: 4, liker_type: "Agency", likeable_id: 4, likeable_type: "Review")
  r.likes.create!(liker_id: 5, liker_type: "Agency", likeable_id: 5, likeable_type: "Review")
end

AdminUser.create!(email: 'poh_kah_kong@tech.gov.sg', password: 'l0v3gdsi', password_confirmation: 'l0v3gdsi') if (Rails.env.development? || Rails.env.test?)