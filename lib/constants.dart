const API_BASE_URL = 'dev.wielabs.com';

const userBox = 'userBox';
const tvResponseBox = 'tvResponseBox';
const movieResponseBox = 'movieResponseBox';
const podcastResponseBox = 'podcastResponseBox';
const feedbackFormUrl = 'https://jhq9jpfct7w.typeform.com/to/WUM55Na2';

final TMDB_MOVIE_GENRES = {
  "28": "Action",
  "12": "Adventure",
  "16": "Animation",
  "35": "Comedy",
  "80": "Crime",
  "99": "Documentary",
  "18": "Drama",
  "10751": "Family",
  "14": "Fantasy",
  "36": "History",
  "27": "Horror",
  "10402": "Music",
  "9648": "Mystery",
  "10749": "Romance",
  "878": "Science Fiction",
  "10770": "TV Movie",
  "53": "Thriller",
  "10752": "War",
  "37": "Western"
};

final TMDB_TV_GENRES = {
  "10759": "Action & Adventure",
  "16": "Animation",
  "35": "Comedy",
  "80": "Crime",
  "99": "Documentary",
  "18": "Drama",
  "10751": "Family",
  "10762": "Kids",
  "9648": "Mystery",
  "10763": "News",
  "10764": "Reality",
  "10765": "Sci-Fi & Fantasy",
  "10766": "Soap",
  "10767": "Talk",
  "10768": "War & Politics",
  "37": "Western"
};

final TMDB_MOVIE_WATCH_PROVIDERS = {
  "8": "Netflix",
  "119": "Amazon Prime Video",
  "250": "Horizon",
  "2": "Apple iTunes",
  "390": "Disney Plus",
  "15": "Hulu",
  "192": "YouTube",
  "384": "HBO Max",
  "72": "Tubi TV",
  "386": "Peacock"
};

final watchProviderWebSites = {
  8: "https://www.netflix.com/",
  119: "https://www.primevideo.com/",
  250: "https://www.horizon.tv",
  2: "https://www.apple.com/in/tv/",
  390: "https://www.disneyplus.com/",
  15: "https://www.hulu.com",
  192: "https://www.youtube.com",
  384: "https://hbomax.com",
  72: "https://tubitv.com/",
  386: "https://peacocktv.com"
};

final SPOTIFY_GENRES = {
  "educational_v2_podcast-shows": "Educational",
  "true-crime_v2_podcast-shows": "True crime",
  "comedy_v2_podcast-shows": "Comedy",
  "society_v2_podcast-shows": "Society & Culture",
  "arts_entertainment_v2_podcast-shows": "Arts & Entertainment",
  "stories_v2_podcast-shows": "Stories",
  "lifestyle_health_v2_podcast-shows": "Lifestyle & Health",
  "news_politics_v2_podcast-shows": "News & Politics",
  "sports_recreation_v2_podcast-shows": "Sports & Recreation",
  "music_v2_podcast-shows": "Music",
  "games_v2_podcast-shows": "Games",
  "business_technology_v2_podcast-shows": "Business & Technology",
  "kids_family_v2_podcast-shows": "Kids & Family",
};

const watchMonetizationTypes = ["flatrate", "free", "ads", "rent", "buy"];

final countriesMap = {
  "dz": "Algeria",
  "ao": "Angola",
  "bw": "Botswana",
  "bi": "Burundi",
  "cm": "Cameroon",
  "cv": "Cape Verde",
  "cf": "Central African Republic",
  "td": "Chad",
  "km": "Comoros",
  "yt": "Mayotte",
  "cg": " Republic of the congo",
  "cd": "Democratic Republic of the congo",
  "bj": "Benin",
  "gq": "Equatorial Guinea",
  "et": "Ethiopia",
  "er": "Eritrea",
  "dj": "Djibouti",
  "ga": "Gabon",
  "gm": "Gambia",
  "gh": "Ghana",
  "gn": "Guinea",
  "ci": "Cote d'Ivoire",
  "ke": "Kenya",
  "ls": "Lesotho",
  "lr": "Liberia",
  "ly": "Libyan Arab Jamahiriya",
  "mg": "Madagascar",
  "mw": "Malawi",
  "ml": "Mali",
  "mr": "Mauritania",
  "mu": "Mauritius",
  "ma": "Morocco",
  "mz": "Mozambique",
  "na": "Namibia",
  "ne": "Niger",
  "ng": "Nigeria",
  "gw": "Guinea-Bissau",
  "re": "Reunion",
  "rw": "Rwanda",
  "sh": "Saint Helena",
  "st": "Sao:me and Principe",
  "sn": "Senegal, Republic of",
  "sc": "Seychelles",
  "sl": "Sierra Leone",
  "so": "Somalia",
  "za": "South Africa",
  "zw": "Zimbabwe",
  "ss": "South Sudan",
  "eh": "Western Sahara",
  "sd": "Sudan",
  "sz": "Swaziland",
  "tg": "Togo",
  "tn": "Tunisia",
  "ug": "Uganda",
  "eg": "Egypt",
  "tz": "Tanzania",
  "bf": "Burkina Faso",
  "zm": "Zambia",
  "aq": "Antarctica",
  "bv": "Bouvet Island",
  "gs": "South Georgia and the South Sandwich Islands",
  "tf": "French Southern Territories",
  "hm": "Heard Island and McDonald Islands",
  "af": "Afghanistan",
  "az": "Azerbaijan",
  "bh": "Bahrain",
  "bd": "Bangladesh",
  "am": "Armenia",
  "bt": "Bhutan",
  "io": "British Indian Ocean Territory",
  "bn": "Brunei",
  "mm": "Myanmar",
  "kh": "Cambodia",
  "lk": "Sri Lanka",
  "cn": "China",
  "tw": "Taiwan",
  "cx": "Christmas Island",
  "cc": "Cocos",
  "cy": "Cyprus",
  "ge": "Georgia",
  "ps": "Palestinian Territory",
  "hk": "Hong Kong",
  "in": "India",
  "id": "Indonesia",
  "ir": "Iran",
  "iq": "Iraq",
  "il": "Israel",
  "jp": "Japan",
  "kz": "Kazakhstan",
  "jo": "Jordan",
  "kp": "Korea",
  "kr": "Korea",
  "kw": "Kuwait",
  "kg": "Kyrgyzstan",
  "la": "Laos",
  "lb": "Lebanon",
  "mo": "Macao",
  "my": "Malaysia",
  "mv": "Maldives",
  "mn": "Mongolia",
  "om": "Oman",
  "np": "Nepal",
  "pk": "Pakistan",
  "ph": "Philippines",
  "tl": "Timor-Leste",
  "qa": "Qatar",
  "ru": "Russian Federation",
  "sa": "Saudi Arabia",
  "sg": "Singapore",
  "vn": "Vietnam",
  "sy": "Syrian Arab Republic",
  "tj": "Tajikistan",
  "th": "Thailand",
  "ae": "United Arab Emirates",
  "tr": "Turkey",
  "tm": "Turkmenistan",
  "uz": "Uzbekistan",
  "ye": "Yemen",
  "al": "Albania",
  "ad": "Andorra",
  "at": "Austria",
  "be": "Belgium",
  "ba": "Bosnia and Herzegovina",
  "bg": "Bulgaria",
  "by": "Belarus",
  "hr": "Croatia",
  "cz": "Czech Republic",
  "dk": "Denmark",
  "ee": "Estonia",
  "fo": "Faroe Islands",
  "fi": "Finland",
  "ax": "Ã…land Islands",
  "fr": "France",
  "de": "Germany",
  "gi": "Gibraltar",
  "gr": "Greece",
  "va": "Holy See",
  "hu": "Hungary",
  "is": "Iceland",
  "ie": "Ireland",
  "it": "Italy",
  "xk": "Kosovo",
  "lv": "Latvia",
  "li": "Liechtenstein",
  "lt": "Lithuania",
  "lu": "Luxembourg",
  "mt": "Malta",
  "mc": "Monaco",
  "md": "Moldova",
  "me": "Montenegro",
  "nl": "Netherlands",
  "no": "Norway",
  "pl": "Poland",
  "pt": "Portugal",
  "ro": "Romania",
  "sm": "San Marino",
  "rs": "Serbia",
  "sk": "Slovakia",
  "si": "Slovenia",
  "es": "Spain",
  "sj": "Svalbard & Jan Mayen Islands",
  "se": "Sweden",
  "ch": "Switzerland",
  "ua": "Ukraine",
  "mk": "Macedonia",
  "gb": "United Kingdom",
  "gb-eng": "England",
  "gb-wls": "Wales",
  "gb-nir": "Northern Ireland",
  "gb-sct": "Scotland",
  "gg": "Guernsey",
  "je": "Jersey",
  "im": "Isle of Man",
  "ag": "Antigua and Barbuda",
  "bs": "Bahamas",
  "bb": "Barbados",
  "bm": "Bermuda",
  "bz": "Belize",
  "vg": "British Virgin Islands",
  "ca": "Canada",
  "ky": "Cayman Islands",
  "cr": "Costa Rica",
  "cu": "Cuba",
  "dm": "Dominica",
  "do": "Dominican Republic",
  "sv": "El Salvador",
  "gl": "Greenland",
  "gd": "Grenada",
  "gp": "Guadeloupe",
  "gt": "Guatemala",
  "ht": "Haiti",
  "hn": "Honduras",
  "jm": "Jamaica",
  "mq": "Martinique",
  "mx": "Mexico",
  "ms": "Montserrat",
  "cw": "CuraÃ§ao",
  "aw": "Aruba",
  "sx": "Sint Maarten",
  "bq": "Bonaire",
  "ni": "Nicaragua",
  "um": "United States",
  "pa": "Panama",
  "pr": "Puerto Rico",
  "bl": "Saint Barthelemy",
  "kn": "Saint Kitts and Nevis",
  "ai": "Anguilla",
  "lc": "Saint Lucia",
  "mf": "Saint Martin",
  "pm": "Saint Pierre and Miquelon",
  "vc": "Saint Vincent and the Grenadines",
  "tt": "Trinidad and:bago",
  "tc": "Turks and Caicos Islands",
  "us": "United States of America",
  "vi": "United States Virgin Islands",
  "ar": "Argentina",
  "bo": "Bolivia",
  "br": "Brazil",
  "cl": "Chile",
  "co": "Colombia",
  "ec": "Ecuador",
  "fk": "Falkland Islands",
  "gf": "French Guiana",
  "gy": "Guyana",
  "py": "Paraguay",
  "pe": "Peru",
  "sr": "Suriname",
  "uy": "Uruguay",
  "ve": "Venezuela",
  "as": "American Samoa",
  "au": "Australia",
  "sb": "Solomon Islands",
  "ck": "Cook Islands",
  "fj": "Fiji",
  "pf": "French Polynesia",
  "ki": "Kiribati",
  "gu": "Guam",
  "nr": "Nauru",
  "nc": "New Caledonia",
  "vu": "Vanuatu",
  "nz": "New Zealand",
  "nu": "Niue",
  "nf": "Norfolk Island",
  "mp": "Northern Mariana Islands",
  "fm": "Micronesia",
  "mh": "Marshall Islands",
  "pw": "Palau",
  "pg": "Papua New Guinea",
  "pn": "Pitcairn Islands",
  "tk": "Tokelau",
  "to": "Tonga",
  "tv": "Tuvalu",
  "wf": "Wallis and Futuna",
  "ws": "Samoa",
};
