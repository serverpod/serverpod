import 'country_model.dart';
import 'country_data.dart';
import 'country_name.dart';

CountryModel getCountryDisplayName(CountryName enumValue) {
  switch (enumValue) {
    case CountryName.afghanistan:
      return countryData.firstWhere((element) => element.name == "Afghanistan");
    case CountryName.alandIslands:
      return countryData
          .firstWhere((element) => element.name == "Åland Islands");
    case CountryName.albania:
      return countryData.firstWhere((element) => element.name == "Albania");
    case CountryName.algeria:
      return countryData.firstWhere((element) => element.name == "Algeria");
    case CountryName.americanSamoa:
      return countryData
          .firstWhere((element) => element.name == "American Samoa");
    case CountryName.andorra:
      return countryData.firstWhere((element) => element.name == "Andorra");
    case CountryName.angola:
      return countryData.firstWhere((element) => element.name == "Angola");
    case CountryName.anguilla:
      return countryData.firstWhere((element) => element.name == "Anguilla");
    case CountryName.antiguaAndBarbuda:
      return countryData
          .firstWhere((element) => element.name == "Antigua and Barbuda");
    case CountryName.argentina:
      return countryData.firstWhere((element) => element.name == "Argentina");
    case CountryName.armenia:
      return countryData.firstWhere((element) => element.name == "Armenia");
    case CountryName.aruba:
      return countryData.firstWhere((element) => element.name == "Aruba");
    case CountryName.ascensionIsland:
      return countryData
          .firstWhere((element) => element.name == "Ascension Island");
    case CountryName.australia:
      return countryData.firstWhere((element) => element.name == "Australia");
    case CountryName.austria:
      return countryData.firstWhere((element) => element.name == "Austria");
    case CountryName.azerbaijan:
      return countryData.firstWhere((element) => element.name == "Azerbaijan");
    case CountryName.bahamas:
      return countryData.firstWhere((element) => element.name == "Bahamas");
    case CountryName.bahrain:
      return countryData.firstWhere((element) => element.name == "Bahrain");
    case CountryName.bangladesh:
      return countryData.firstWhere((element) => element.name == "Bangladesh");
    case CountryName.barbados:
      return countryData.firstWhere((element) => element.name == "Barbados");
    case CountryName.belarus:
      return countryData.firstWhere((element) => element.name == "Belarus");
    case CountryName.belgium:
      return countryData.firstWhere((element) => element.name == "Belgium");
    case CountryName.belize:
      return countryData.firstWhere((element) => element.name == "Belize");
    case CountryName.benin:
      return countryData.firstWhere((element) => element.name == "Benin");
    case CountryName.bermuda:
      return countryData.firstWhere((element) => element.name == "Bermuda");
    case CountryName.bhutan:
      return countryData.firstWhere((element) => element.name == "Bhutan");
    case CountryName.bolivia:
      return countryData.firstWhere((element) => element.name == "Bolivia");
    case CountryName.bosniaAndHerzegovina:
      return countryData
          .firstWhere((element) => element.name == "Bosnia and Herzegovina");
    case CountryName.botswana:
      return countryData.firstWhere((element) => element.name == "Botswana");
    case CountryName.brazil:
      return countryData.firstWhere((element) => element.name == "Brazil");
    case CountryName.britishIndianOceanTerritory:
      return countryData.firstWhere(
          (element) => element.name == "British Indian Ocean Territory");
    case CountryName.britishVirginIslands:
      return countryData
          .firstWhere((element) => element.name == "British Virgin Islands");
    case CountryName.brunei:
      return countryData.firstWhere((element) => element.name == "Brunei");
    case CountryName.bulgaria:
      return countryData.firstWhere((element) => element.name == "Bulgaria");
    case CountryName.burkinaFaso:
      return countryData
          .firstWhere((element) => element.name == "Burkina Faso");
    case CountryName.burundi:
      return countryData.firstWhere((element) => element.name == "Burundi");
    case CountryName.cambodia:
      return countryData.firstWhere((element) => element.name == "Cambodia");
    case CountryName.cameroon:
      return countryData.firstWhere((element) => element.name == "Cameroon");
    case CountryName.canada:
      return countryData.firstWhere((element) => element.name == "Canada");
    case CountryName.capeVerde:
      return countryData.firstWhere((element) => element.name == "Cape Verde");
    case CountryName.caribbeanNetherlands:
      return countryData
          .firstWhere((element) => element.name == "Caribbean Netherlands");
    case CountryName.caymanIslands:
      return countryData
          .firstWhere((element) => element.name == "Cayman Islands");
    case CountryName.centralAfricanRepublic:
      return countryData
          .firstWhere((element) => element.name == "Central African Republic");
    case CountryName.chad:
      return countryData.firstWhere((element) => element.name == "Chad");
    case CountryName.chile:
      return countryData.firstWhere((element) => element.name == "Chile");
    case CountryName.china:
      return countryData.firstWhere((element) => element.name == "China");
    case CountryName.christmasIsland:
      return countryData
          .firstWhere((element) => element.name == "Christmas Island");
    case CountryName.cocosKeelingIslands:
      return countryData
          .firstWhere((element) => element.name == "Cocos [Keeling] Islands");
    case CountryName.colombia:
      return countryData.firstWhere((element) => element.name == "Colombia");
    case CountryName.comoros:
      return countryData.firstWhere((element) => element.name == "Comoros");
    case CountryName.democraticRepublicCongo:
      return countryData
          .firstWhere((element) => element.name == "Democratic Republic Congo");
    case CountryName.republicOfCongo:
      return countryData
          .firstWhere((element) => element.name == "Republic of Congo");
    case CountryName.cookIslands:
      return countryData
          .firstWhere((element) => element.name == "Cook Islands");
    case CountryName.costaRica:
      return countryData.firstWhere((element) => element.name == "Costa Rica");
    case CountryName.coteDIvoire:
      return countryData
          .firstWhere((element) => element.name == "Côte d'Ivoire");
    case CountryName.croatia:
      return countryData.firstWhere((element) => element.name == "Croatia");
    case CountryName.cuba:
      return countryData.firstWhere((element) => element.name == "Cuba");
    case CountryName.Curacao:
      return countryData.firstWhere((element) => element.name == "Curaçao");
    case CountryName.cyprus:
      return countryData.firstWhere((element) => element.name == "Cyprus");
    case CountryName.czechRepublic:
      return countryData
          .firstWhere((element) => element.name == "Czech Republic");
    case CountryName.denmark:
      return countryData.firstWhere((element) => element.name == "Denmark");
    case CountryName.djibouti:
      return countryData.firstWhere((element) => element.name == "Djibouti");
    case CountryName.dominica:
      return countryData.firstWhere((element) => element.name == "Dominica");
    case CountryName.dominicanRepublic:
      return countryData
          .firstWhere((element) => element.name == "Dominican Republic");
    case CountryName.eastTimor:
      return countryData.firstWhere((element) => element.name == "East Timor");
    case CountryName.ecuador:
      return countryData.firstWhere((element) => element.name == "Ecuador");
    case CountryName.egypt:
      return countryData.firstWhere((element) => element.name == "Egypt");
    case CountryName.elSalvador:
      return countryData.firstWhere((element) => element.name == "El Salvador");
    case CountryName.equatorialGuinea:
      return countryData
          .firstWhere((element) => element.name == "Equatorial Guinea");
    case CountryName.eritrea:
      return countryData.firstWhere((element) => element.name == "Eritrea");
    case CountryName.estonia:
      return countryData.firstWhere((element) => element.name == "Estonia");
    case CountryName.eswatini:
      return countryData.firstWhere((element) => element.name == "Eswatini");
    case CountryName.ethiopia:
      return countryData.firstWhere((element) => element.name == "Ethiopia");
    case CountryName.falklandIslandsIslasMalvinas:
      return countryData.firstWhere(
          (element) => element.name == "Falkland Islands [Islas Malvinas]");
    case CountryName.faroeIslands:
      return countryData
          .firstWhere((element) => element.name == "Faroe Islands");
    case CountryName.fiji:
      return countryData.firstWhere((element) => element.name == "Fiji");
    case CountryName.finland:
      return countryData.firstWhere((element) => element.name == "Finland");
    case CountryName.france:
      return countryData.firstWhere((element) => element.name == "France");
    case CountryName.frenchGuiana:
      return countryData
          .firstWhere((element) => element.name == "French Guiana");
    case CountryName.frenchPolynesia:
      return countryData
          .firstWhere((element) => element.name == "French Polynesia");
    case CountryName.gabon:
      return countryData.firstWhere((element) => element.name == "Gabon");
    case CountryName.gambia:
      return countryData.firstWhere((element) => element.name == "Gambia");
    case CountryName.georgia:
      return countryData.firstWhere((element) => element.name == "Georgia");
    case CountryName.germany:
      return countryData.firstWhere((element) => element.name == "Germany");
    case CountryName.ghana:
      return countryData.firstWhere((element) => element.name == "Ghana");
    case CountryName.gibraltar:
      return countryData.firstWhere((element) => element.name == "Gibraltar");
    case CountryName.greece:
      return countryData.firstWhere((element) => element.name == "Greece");
    case CountryName.greenland:
      return countryData.firstWhere((element) => element.name == "Greenland");
    case CountryName.grenada:
      return countryData.firstWhere((element) => element.name == "Grenada");
    case CountryName.guadeloupe:
      return countryData.firstWhere((element) => element.name == "Guadeloupe");
    case CountryName.guam:
      return countryData.firstWhere((element) => element.name == "Guam");
    case CountryName.guatemala:
      return countryData.firstWhere((element) => element.name == "Guatemala");
    case CountryName.guernsey:
      return countryData.firstWhere((element) => element.name == "Guernsey");
    case CountryName.guineaConakry:
      return countryData
          .firstWhere((element) => element.name == "Guinea Conakry");
    case CountryName.guineaBissau:
      return countryData
          .firstWhere((element) => element.name == "Guinea-Bissau");
    case CountryName.guyana:
      return countryData.firstWhere((element) => element.name == "Guyana");
    case CountryName.haiti:
      return countryData.firstWhere((element) => element.name == "Haiti");
    case CountryName.heardIslandAndMcDonaldIslands:
      return countryData.firstWhere(
          (element) => element.name == "Heard Island and McDonald Islands");
    case CountryName.honduras:
      return countryData.firstWhere((element) => element.name == "Honduras");
    case CountryName.hongKong:
      return countryData.firstWhere((element) => element.name == "Hong Kong");
    case CountryName.hungary:
      return countryData.firstWhere((element) => element.name == "Hungary");
    case CountryName.iceland:
      return countryData.firstWhere((element) => element.name == "Iceland");
    case CountryName.india:
      return countryData.firstWhere((element) => element.name == "India");
    case CountryName.indonesia:
      return countryData.firstWhere((element) => element.name == "Indonesia");
    case CountryName.iran:
      return countryData.firstWhere((element) => element.name == "Iran");
    case CountryName.iraq:
      return countryData.firstWhere((element) => element.name == "Iraq");
    case CountryName.ireland:
      return countryData.firstWhere((element) => element.name == "Ireland");
    case CountryName.isleOfMan:
      return countryData.firstWhere((element) => element.name == "Isle of Man");
    case CountryName.israel:
      return countryData.firstWhere((element) => element.name == "Israel");
    case CountryName.italy:
      return countryData.firstWhere((element) => element.name == "Italy");
    case CountryName.jamaica:
      return countryData.firstWhere((element) => element.name == "Jamaica");
    case CountryName.japan:
      return countryData.firstWhere((element) => element.name == "Japan");
    case CountryName.jersey:
      return countryData.firstWhere((element) => element.name == "Jersey");
    case CountryName.jordan:
      return countryData.firstWhere((element) => element.name == "Jordan");
    case CountryName.kazakhstan:
      return countryData.firstWhere((element) => element.name == "Kazakhstan");
    case CountryName.kenya:
      return countryData.firstWhere((element) => element.name == "Kenya");
    case CountryName.kiribati:
      return countryData.firstWhere((element) => element.name == "Kiribati");
    case CountryName.kosovo:
      return countryData.firstWhere((element) => element.name == "Kosovo");
    case CountryName.kuwait:
      return countryData.firstWhere((element) => element.name == "Kuwait");
    case CountryName.kyrgyzstan:
      return countryData.firstWhere((element) => element.name == "Kyrgyzstan");
    case CountryName.laos:
      return countryData.firstWhere((element) => element.name == "Laos");
    case CountryName.latvia:
      return countryData.firstWhere((element) => element.name == "Latvia");
    case CountryName.lebanon:
      return countryData.firstWhere((element) => element.name == "Lebanon");
    case CountryName.lesotho:
      return countryData.firstWhere((element) => element.name == "Lesotho");
    case CountryName.liberia:
      return countryData.firstWhere((element) => element.name == "Liberia");
    case CountryName.libya:
      return countryData.firstWhere((element) => element.name == "Libya");
    case CountryName.liechtenstein:
      return countryData
          .firstWhere((element) => element.name == "Liechtenstein");
    case CountryName.lithuania:
      return countryData.firstWhere((element) => element.name == "Lithuania");
    case CountryName.luxembourg:
      return countryData.firstWhere((element) => element.name == "Luxembourg");
    case CountryName.macau:
      return countryData.firstWhere((element) => element.name == "Macau");
    case CountryName.macedonia:
      return countryData.firstWhere((element) => element.name == "Macedonia");
    case CountryName.madagascar:
      return countryData.firstWhere((element) => element.name == "Madagascar");
    case CountryName.malawi:
      return countryData.firstWhere((element) => element.name == "Malawi");
    case CountryName.malaysia:
      return countryData.firstWhere((element) => element.name == "Malaysia");
    case CountryName.maldives:
      return countryData.firstWhere((element) => element.name == "Maldives");
    case CountryName.mali:
      return countryData.firstWhere((element) => element.name == "Mali");
    case CountryName.malta:
      return countryData.firstWhere((element) => element.name == "Malta");
    case CountryName.marshallIslands:
      return countryData
          .firstWhere((element) => element.name == "Marshall Islands");
    case CountryName.martinique:
      return countryData.firstWhere((element) => element.name == "Martinique");
    case CountryName.mauritania:
      return countryData.firstWhere((element) => element.name == "Mauritania");
    case CountryName.mauritius:
      return countryData.firstWhere((element) => element.name == "Mauritius");
    case CountryName.mayotte:
      return countryData.firstWhere((element) => element.name == "Mayotte");
    case CountryName.mexico:
      return countryData.firstWhere((element) => element.name == "Mexico");
    case CountryName.micronesia:
      return countryData.firstWhere((element) => element.name == "Micronesia");
    case CountryName.moldova:
      return countryData.firstWhere((element) => element.name == "Moldova");
    case CountryName.monaco:
      return countryData.firstWhere((element) => element.name == "Monaco");
    case CountryName.mongolia:
      return countryData.firstWhere((element) => element.name == "Mongolia");
    case CountryName.montenegro:
      return countryData.firstWhere((element) => element.name == "Montenegro");
    case CountryName.montserrat:
      return countryData.firstWhere((element) => element.name == "Montserrat");
    case CountryName.morocco:
      return countryData.firstWhere((element) => element.name == "Morocco");
    case CountryName.mozambique:
      return countryData.firstWhere((element) => element.name == "Mozambique");
    case CountryName.myanmarBurma:
      return countryData
          .firstWhere((element) => element.name == "Myanmar [Burma]");
    case CountryName.namibia:
      return countryData.firstWhere((element) => element.name == "Namibia");
    case CountryName.nauru:
      return countryData.firstWhere((element) => element.name == "Nauru");
    case CountryName.nepal:
      return countryData.firstWhere((element) => element.name == "Nepal");
    case CountryName.netherlands:
      return countryData.firstWhere((element) => element.name == "Netherlands");
    case CountryName.newCaledonia:
      return countryData
          .firstWhere((element) => element.name == "New Caledonia");
    case CountryName.newZealand:
      return countryData.firstWhere((element) => element.name == "New Zealand");
    case CountryName.nicaragua:
      return countryData.firstWhere((element) => element.name == "Nicaragua");
    case CountryName.niger:
      return countryData.firstWhere((element) => element.name == "Niger");
    case CountryName.nigeria:
      return countryData.firstWhere((element) => element.name == "Nigeria");
    case CountryName.niue:
      return countryData.firstWhere((element) => element.name == "Niue");
    case CountryName.norfolkIsland:
      return countryData
          .firstWhere((element) => element.name == "Norfolk Island");
    case CountryName.northKorea:
      return countryData.firstWhere((element) => element.name == "North Korea");
    case CountryName.northernMarianaIslands:
      return countryData
          .firstWhere((element) => element.name == "Northern Mariana Islands");
    case CountryName.norway:
      return countryData.firstWhere((element) => element.name == "Norway");
    case CountryName.oman:
      return countryData.firstWhere((element) => element.name == "Oman");
    case CountryName.pakistan:
      return countryData.firstWhere((element) => element.name == "Pakistan");
    case CountryName.palau:
      return countryData.firstWhere((element) => element.name == "Palau");
    case CountryName.palestinianTerritories:
      return countryData
          .firstWhere((element) => element.name == "Palestinian Territories");
    case CountryName.panama:
      return countryData.firstWhere((element) => element.name == "Panama");
    case CountryName.papuaNewGuinea:
      return countryData
          .firstWhere((element) => element.name == "Papua New Guinea");
    case CountryName.paraguay:
      return countryData.firstWhere((element) => element.name == "Paraguay");
    case CountryName.peru:
      return countryData.firstWhere((element) => element.name == "Peru");
    case CountryName.philippines:
      return countryData.firstWhere((element) => element.name == "Philippines");
    case CountryName.poland:
      return countryData.firstWhere((element) => element.name == "Poland");
    case CountryName.portugal:
      return countryData.firstWhere((element) => element.name == "Portugal");
    case CountryName.puertoRico:
      return countryData.firstWhere((element) => element.name == "Puerto Rico");
    case CountryName.qatar:
      return countryData.firstWhere((element) => element.name == "Qatar");
    case CountryName.Reunion:
      return countryData.firstWhere((element) => element.name == "Réunion");
    case CountryName.romania:
      return countryData.firstWhere((element) => element.name == "Romania");
    case CountryName.russia:
      return countryData.firstWhere((element) => element.name == "Russia");
    case CountryName.rwanda:
      return countryData.firstWhere((element) => element.name == "Rwanda");
    case CountryName.saintBarthelemy:
      return countryData
          .firstWhere((element) => element.name == "Saint Barthélemy");
    case CountryName.saintHelena:
      return countryData
          .firstWhere((element) => element.name == "Saint Helena");
    case CountryName.stKitts:
      return countryData.firstWhere((element) => element.name == "St. Kitts");
    case CountryName.stLucia:
      return countryData.firstWhere((element) => element.name == "St. Lucia");
    case CountryName.saintMartin:
      return countryData
          .firstWhere((element) => element.name == "Saint Martin");
    case CountryName.saintPierreAndMiquelon:
      return countryData
          .firstWhere((element) => element.name == "Saint Pierre and Miquelon");
    case CountryName.stVincent:
      return countryData.firstWhere((element) => element.name == "St. Vincent");
    case CountryName.samoa:
      return countryData.firstWhere((element) => element.name == "Samoa");
    case CountryName.sanMarino:
      return countryData.firstWhere((element) => element.name == "San Marino");
    case CountryName.saoTomeAndPrincipe:
      return countryData
          .firstWhere((element) => element.name == "São Tomé and Príncipe");
    case CountryName.saudiArabia:
      return countryData
          .firstWhere((element) => element.name == "Saudi Arabia");
    case CountryName.senegal:
      return countryData.firstWhere((element) => element.name == "Senegal");
    case CountryName.serbia:
      return countryData.firstWhere((element) => element.name == "Serbia");
    case CountryName.seychelles:
      return countryData.firstWhere((element) => element.name == "Seychelles");
    case CountryName.sierraLeone:
      return countryData
          .firstWhere((element) => element.name == "Sierra Leone");
    case CountryName.singapore:
      return countryData.firstWhere((element) => element.name == "Singapore");
    case CountryName.sintMaarten:
      return countryData
          .firstWhere((element) => element.name == "Sint Maarten");
    case CountryName.slovakia:
      return countryData.firstWhere((element) => element.name == "Slovakia");
    case CountryName.slovenia:
      return countryData.firstWhere((element) => element.name == "Slovenia");
    case CountryName.solomonIslands:
      return countryData
          .firstWhere((element) => element.name == "Solomon Islands");
    case CountryName.somalia:
      return countryData.firstWhere((element) => element.name == "Somalia");
    case CountryName.southAfrica:
      return countryData
          .firstWhere((element) => element.name == "South Africa");
    case CountryName.southGeorgiaAndTheSouthSandwichIslands:
      return countryData.firstWhere((element) =>
          element.name == "South Georgia and the South Sandwich Islands");
    case CountryName.southKorea:
      return countryData.firstWhere((element) => element.name == "South Korea");
    case CountryName.southSudan:
      return countryData.firstWhere((element) => element.name == "South Sudan");
    case CountryName.spain:
      return countryData.firstWhere((element) => element.name == "Spain");
    case CountryName.sriLanka:
      return countryData.firstWhere((element) => element.name == "Sri Lanka");
    case CountryName.sudan:
      return countryData.firstWhere((element) => element.name == "Sudan");
    case CountryName.suriname:
      return countryData.firstWhere((element) => element.name == "Suriname");
    case CountryName.svalbardAndJanMayen:
      return countryData
          .firstWhere((element) => element.name == "Svalbard and Jan Mayen");
    case CountryName.sweden:
      return countryData.firstWhere((element) => element.name == "Sweden");
    case CountryName.switzerland:
      return countryData.firstWhere((element) => element.name == "Switzerland");
    case CountryName.syria:
      return countryData.firstWhere((element) => element.name == "Syria");
    case CountryName.taiwan:
      return countryData.firstWhere((element) => element.name == "Taiwan");
    case CountryName.tajikistan:
      return countryData.firstWhere((element) => element.name == "Tajikistan");
    case CountryName.tanzania:
      return countryData.firstWhere((element) => element.name == "Tanzania");
    case CountryName.thailand:
      return countryData.firstWhere((element) => element.name == "Thailand");
    case CountryName.togo:
      return countryData.firstWhere((element) => element.name == "Togo");
    case CountryName.tokelau:
      return countryData.firstWhere((element) => element.name == "Tokelau");
    case CountryName.tonga:
      return countryData.firstWhere((element) => element.name == "Tonga");
    case CountryName.trinidadTobago:
      return countryData
          .firstWhere((element) => element.name == "Trinidad/Tobago");
    case CountryName.tunisia:
      return countryData.firstWhere((element) => element.name == "Tunisia");
    case CountryName.turkey:
      return countryData.firstWhere((element) => element.name == "Turkey");
    case CountryName.turkmenistan:
      return countryData
          .firstWhere((element) => element.name == "Turkmenistan");
    case CountryName.turksAndCaicosIslands:
      return countryData
          .firstWhere((element) => element.name == "Turks and Caicos Islands");
    case CountryName.tuvalu:
      return countryData.firstWhere((element) => element.name == "Tuvalu");
    case CountryName.usVirginIslands:
      return countryData
          .firstWhere((element) => element.name == "U.S. Virgin Islands");
    case CountryName.uganda:
      return countryData.firstWhere((element) => element.name == "Uganda");
    case CountryName.ukraine:
      return countryData.firstWhere((element) => element.name == "Ukraine");
    case CountryName.unitedArabEmirates:
      return countryData
          .firstWhere((element) => element.name == "United Arab Emirates");
    case CountryName.unitedKingdom:
      return countryData
          .firstWhere((element) => element.name == "United Kingdom");
    case CountryName.unitedStates:
      return countryData
          .firstWhere((element) => element.name == "United States");
    case CountryName.uruguay:
      return countryData.firstWhere((element) => element.name == "Uruguay");
    case CountryName.uzbekistan:
      return countryData.firstWhere((element) => element.name == "Uzbekistan");
    case CountryName.vanuatu:
      return countryData.firstWhere((element) => element.name == "Vanuatu");
    case CountryName.vaticanCity:
      return countryData
          .firstWhere((element) => element.name == "Vatican City");
    case CountryName.venezuela:
      return countryData.firstWhere((element) => element.name == "Venezuela");
    case CountryName.vietnam:
      return countryData.firstWhere((element) => element.name == "Vietnam");
    case CountryName.wallisAndFutuna:
      return countryData
          .firstWhere((element) => element.name == "Wallis and Futuna");
    case CountryName.westernSahara:
      return countryData
          .firstWhere((element) => element.name == "Western Sahara");
    case CountryName.yemen:
      return countryData.firstWhere((element) => element.name == "Yemen");
    case CountryName.zambia:
      return countryData.firstWhere((element) => element.name == "Zambia");
    case CountryName.zimbabwe:
      return countryData.firstWhere((element) => element.name == "Zimbabwe");
  }
}
