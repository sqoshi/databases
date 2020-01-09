#Z1
use MBDHobby;
#Z2

db.sport.insert(
[{"nazwa" : "Piłka Nożna", "miejsce" : ["hala","na zewnątrz"], "typ" : "zespołowy"},
{"nazwa" : "Boks", "miejsce" : "hala", "typ" : "indywidualny" },
{"nazwa" : "Rugby", "miejsce" : "na zewnątrz", "typ" : "zespołowy" },
{"nazwa" : "Biegi", "miejsce" : "na zewnątrz", "typ" : ["indywidualny","zespołowy"] },
{"nazwa" : "Pływanie", "miejsce" : ["hala","na zewnątrz"], "typ" : ["zespołowy","indywidualny"] },
{"nazwa" : "Esport", "miejsce" : "hala", "typ" : ["zespołowy","indywidualny"] },
{"nazwa" : "Siatkówka", "miejsce" : "hala", "typ" : "zespołowy" },
{"nazwa" : "Golf", "miejsce" : "na zewnątrz", "typ" : "indywidualny" },
{"nazwa" : "Rugby", "miejsce" : "na zewnątrz", "typ" : "zespołowy" },
{"nazwa" : "Tenis", "miejsce" : ["hala", "na zewnątrz"], "typ" : ["indywidualny","zespołowy"]}]);

#Z3
db.zwierzęta.insert(
[{"Gatunek" : "Kot", "rasa" : ["dachowiec","himalajski","brytyjski"], "Umaszczenia" : ["Szary","Czarny","Biały","W centki"], "Maksymalna Waga":4.5,"Minimalna Waga":3.5,"Oczekiwana długość życia":8},
{"Gatunek" : "Pies", "rasa" : ["Doberman","Owczarek  Niemiecki","Pitbull","Pasterski"], "Umaszczenia" : ["Podpalany","Czarny","Biały","Niebieski","Mieszany"], "Maksymalna Waga":85,"Minimalna Waga":3,"Oczekiwana długość życia":11},
{"Gatunek" : "Koza", "rasa" : ["Górska","Domowa"], "Umaszczenia" : ["Brązowy","Czarny","Biały"], "Maksymalna Waga":120,"Minimalna Waga":20,"Oczekiwana długość życia":18},
{"Gatunek" : "Smok", "Umaszczenia" : ["Przezroczysty","Zielony","Czerwony"], "Maksymalna Waga":30000,"Minimalna Waga":24000,"Oczekiwana długość życia":90},
{"Gatunek" : "Mysz", "Umaszczenia" : ["Szara","Biała"], "Maksymalna Waga":0.030,"Minimalna Waga":0.015,"Oczekiwana długość życia":2},
{"Gatunek" : "Lew", "Umaszczenia" : ["Żółto-brązowy","Biały"], "Maksymalna Waga":200,"Minimalna Waga":120,"Oczekiwana długość życia":14},
{"Gatunek" : "Wąż", "rasa" : ["Pyton","Kobra"], "Umaszczenia" : ["Czarny","Mieszany","Zielony"], "Maksymalna Waga":6,"Minimalna Waga":0.5,"Oczekiwana długość życia":25},
{"Gatunek" : "Ptak", "rasa" : ["Bocian","Wróbel","Kruk","Sowa"], "Umaszczenia" : ["Czarny","Mieszany","Szary","Biały"], "Maksymalna Waga":7,"Minimalna Waga":0.03,"Oczekiwana długość życia":25},
{"Gatunek" : "Ryba", "rasa" : ["Łosoś","Pstrąg","Okoń","Sum"], "Umaszczenia" : ["Czarny","Mieszany","Srebrzysty"], "Maksymalna Waga":6,"Minimalna Waga":1,"Oczekiwana długość życia":25},
{"Gatunek" : "Słoń", "rasa" : ["Indyjski","Afrykański"], "Umaszczenia" : "Szary", "Maksymalna Waga":8000,"Minimalna Waga":6000,"Oczekiwana długość życia":80},
]);

#Z4 prz y uzyciu json-generator.com
[
  '{{repeat(50, 51)}}',
  {
    _id: '{{objectId()}}',
    index: '{{index()}}',
    imie: '{{firstName()}}',
    nazwisko: '{{surname()}}',
    wiek: '{{floating(18, 75,1, "0")}}',
    wzrost:'{{floating(160, 202,1 , "0")}}',
    zainteresowania: [ 
      '{{random("Piłka Nożna","Boks","Rugby","Biegi","Pływanie","Esport","Siatkówka","Golf","Rugby","Tenis")}}',  
     '{{random("Piłka Nożna","Boks","Rugby","Biegi","Pływanie","Esport","Siatkówka","Golf","Rugby","Tenis")}}'
                ],
    narodowosc: [
          '{{country()}}',
          '{{country()}}'
                           
      ],
	Kraj: ' {{country()}}',    
    gatunek: '{{random("Pies","Kot","Koza","Smok", "Mysz", "Lew", "Wąż" ,"Ryba", "Słoń")}}',
    imieZwierzaka: '{{firstName()}}'
   
  }
]