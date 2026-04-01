insert into airports(regionID, place, name, IATA) values
-- North America
(1, "Austin, TX", "Austin-Bergstrom Intl", "AUS"),
(1, "New York, NYC", "John F Kennedy Intl", "JFK"),
(1, "San Francisco, CA", "San Francisco Intl.", "SFO"),

-- South America
(2, "São Paulo, Brazil", "Guarulhos Intl", "GRU"),
(2, "Buenos Aires, Argentina", "Ministro Pistarini Intl", "EZE"),
(2, "Bogotá, Colombia", "El Dorado Intl", "BOG"),

-- Asia
(3, "Tokyo, Japan", "Haneda Intl", "HND"),
(3, "Dubai, UAE", "Dubai Intl", "DXB"),
(3, "Singapore, Singapore", "Changi Intl", "SIN"),

-- Europe
(4, "London, UK", "Heathrow Intl", "LHR"),
(4, "Paris, France", "Charles de Gaulle Intl", "CDG"),
(4, "Frankfurt, Germany", "Frankfurt am Main Intl", "FRA"),

-- Africa
(5, "Johannesburg, South Africa", "O.R. Tambo Intl", "JNB"),
(5, "Cairo, Egypt", "Cairo Intl", "CAI"),
(5, "Nairobi, Kenya", "Jomo Kenyatta Intl", "NBO");





insert into flight (IATA, planeName, gate, origin, destination, capacity, assignedPilot) values
("TP1007", "IronFalcon", "A1", 1, 2, 20, 204),
("TP1009", "BlueDart", "D3", 1, 3, 24, 202),
("TP1011", "StormRider", "C3", 1, 4, 16, 207),
("TP1013", "NovaStar", "A1", 2, 3, 4, 204),
("TP1015", "ArcticBreeze", "D1", 2, 1, 20, 204),
("TP1017", "CoastalAce", "B2", 2, 5, 8, 200),
("TP1019", "ApexGlider", "A3", 3, 1, 12, 200),
("TP1021", "MidnightRun", "B3", 3, 2, 28, 204),
("TP1023", "CloudPiercer", "B2", 3, 4, 16, 202),
("TP1025", "EclipseJet", "B2", 4, 1, 28, 201),
("TP1027", "SwiftArrow", "A1", 4, 2, 28, 207),
("TP1029", "CycloneX", "B3", 4, 5, 32, 205),
("TP1031", "TwilightAce", "C2", 5, 3, 32, 202),
("TP1033", "SkyLancer", "A2", 5, 1, 16, 201),
("TP1035", "NorthStar", "C3", 5, 4, 16, 207),

("TP1037", "TurboCondor", "A1", 1, 3, 12, 204),
("TP1039", "HighRoller", "B1", 1, 5, 32, 200),
("TP1041", "MachRacer", "D3", 2, 4, 8, 205),
("TP1043", "CobaltJet", "D2", 2, 3, 8, 201),
("TP1045", "HorizonX", "C1", 3, 5, 20, 205),
("TP1047", "AltitudePro", "A3", 3, 1, 4, 201),
("TP1049", "BlackKite", "B1", 4, 3, 28, 205),
("TP1051", "MercuryWing", "A1", 4, 2, 12, 201),
("TP1053", "CrimsonAce", "D3", 5, 3, 28, 205),
("TP1055", "BronzeArrow", "B3", 5, 1, 28, 201),

("TP1057", "DiamondAir", "D2", 1, 4, 28, 205),
("TP1059", "SapphireGlide", "C2", 2, 5, 20, 200),
("TP1061", "AmethystWing", "D1", 3, 4, 32, 200),
("TP1063", "OpalSky", "D3", 4, 1, 32, 206),
("TP1065", "PeridotFlight", "C2", 5, 2, 8, 204),
("TP1067", "QuartzSprint", "B3", 1, 5, 32, 203),
("TP1069", "MarbleAce", "B2", 2, 3, 32, 201),
("TP1071", "SlateHawk", "D1", 3, 1, 32, 206),
("TP1073", "CanyonRunner", "B2", 4, 2, 32, 205),
("TP1075", "DeltaGlide", "A3", 5, 3, 24, 202),

("TP1077", "ZetaWing", "B3", 1, 4, 28, 202),
("TP1079", "ThetaStar", "A1", 2, 1, 8, 207),
("TP1081", "KappaAir", "A2", 3, 5, 4, 205),
("TP1083", "MuWing", "C3", 4, 3, 24, 204),
("TP1085", "XiGlide", "C2", 5, 1, 24, 202),
("TP1087", "PiAce", "D3", 1, 2, 24, 200),
("TP1089", "SigmaFlight", "B2", 2, 4, 24, 206),
("TP1091", "UpsilonJet", "D2", 3, 1, 20, 203),
("TP1093", "ChiHawk", "C3", 4, 2, 16, 200),
("TP1095", "OmegaAce", "D1", 5, 3, 16, 206);