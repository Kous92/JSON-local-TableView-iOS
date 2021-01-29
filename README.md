# Parsing JSON avec TableView + Tests unitaires iOS (Swift 5)

Parser des données sous format **JSON (JavaScript Object Notation)** est courant dans le développement mobile, notamment:
- Lorsqu'on télécharge ces données depuis un serveur (API REST) par des requêtes HTTP.
- Lorsqu'il faut disposer ces données dans des listes visuelles (TableView) avec des cellules personnalisées (TableViewCell).

Ici, grâce à Swift, il est nettement plus simple de parser le JSON dans des objets (généralement des structures) avec le protocole `Codable` (qui combine `Encodable` et `Decodable`). Ici, je vous propose un cas pratiques avec des données de voitures de type supercar et Hypercar avec:
- ViewController contenant une liste sous TableView où dans chaque cellule (TableViewCell) le logo et le nom de la marque automobile, et une barre de recherche pour filtrer les marques automobiles.
- Au clic sur une cellule de la liste, un ViewController contenant le nom et le logo de la marque automobile, une liste sous TableView où dans chaque cellule (TableViewCell) contient le nom et des informations sur chaque modèle enregistré de la marque.

Concernant l'application:
- Architecture de l'application: **MVC**
- Version de déploiement: **iOS 14.0**
- Version de Swift: **5.3**
- Tests unitaires avec **XCTest**
- Pourcentage de couverture du code par les tests: **35%**

Le code à disposition est donc un modèle pour le développement de ses propres applications effectuant des appels réseau pour envoyer et récupérer des données.

## Important à savoir

Le code de l'application iOS est structurée de l'architecture (design pattern) la plus simple: MVC (Model View Controller)

### Partie modèle (Model)

**L'idée est la suivante:**

- Je dispose d'un fichier JSON contenant les données suivantes:
```json
{
    "cars": [
        {
            "brandName": "McLaren",
            "imageName": "mclaren-logo",
            "models": [
                {
                    "modelName": "F1",
                    "year": 1992,
                    "engine": "V12",
                    "power": 627,
                    "maxSpeed": 391,
                    "price": 1000000
                },
                {
                    "modelName": "Speedtail",
                    "year": 2020,
                    "engine": "V8 Hybride",
                    "power": 1070,
                    "maxSpeed": 403,
                    "price": 2400000
                }
            ]
        }
    ]
}
```

Au lieu de faire de façon fastidieuse et compliquée avec des boucles pour itérer entre les objets et tableaux JSON, Swift propose le protocole `Codable` (pour encoder et décoder les données) qu'on fait implémenter à chaque structure en tant qu'objet de données, comme ceci:
```swift
struct CarBrands: Codable {
    let cars: [Cars]?
}

struct Cars: Codable {
    let brandName: String?
    let imageName: String?
    let models: [Car]?
}

struct Car: Codable {
    let modelName: String?
    let year: Int?
    let engine: String?
    let power: Int?
    let maxSpeed: Int?
    let price: Int?
}
```

De plus, chaque attribut est optionnel en cas d'incertitude sur le contenu. Dans la réalité, les données JSON que les API REST nous fournissent peuvent contenir des attributs valant `null`. 

Ici, avec le fichier local `data.json` dans le projet, les données lues dans le fichier sont converties en type `Data`, le même type qu'on exploite lorsqu'on récupère la réponse de la requête HTTP d'un serveur. Avec ces données JSON, on tente de les décoder sous objets en Swift afin de les exploiter dans les TableView.
```swift
// Vérification de l'existence du fichier data.json
guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
    return
}

let url = URL(fileURLWithPath: path)
var listeVoitures: CarBrands?

do {
    // Récupération des données JSON en type Data
    let data = try Data(contentsOf: url)

    // Décodage des données JSON en objets exploitables
    listeVoitures = try JSONDecoder().decode(CarBrands.self, from: data)
    
    if let result = listeVoitures {
        print(result)
        
        if let cars = result.cars {
            carBrands = cars
            // print(carBrands)
        }
    } else {
        print("Échec lors du décodage des données")
    }
} catch {
    print("ERREUR: \(error)")
}
```

### Partie contrôleur (Controller)

Ici, le `ViewController` principal contient un `TableView`, les protocoles `UITableViewDelegate` (pour les actions sur la liste) et `UITableViewDataSource` sont implémentées. Il y contient également une barre de recherche pour le filtrage des données, cela grâce au protocole `UISearchBarDelegate`.

- **IMPORTANT: Ne pas oublier de pointer les delegates et data sources des `TableView` et `SearchBar` pour pouvoir exécuter les fonctionnalités des protocoles, comme ci-dessous.**
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    listeMarquesVoitures.delegate = self
    listeMarquesVoitures.dataSource = self
    barreRecherche.delegate = self
    
    initialiserListe()
    filteredCarBrands = carBrands
}
```

**Actions sur le `TableView` des marques automobiles**:
- Le nombre de cellules dépend du nombre de marques filtrées, par défaut toutes les marques enregistrées dans les données JSON de `data.json`:
```swift
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredCarBrands.count
}
```

- Cellule personnalisée contenant le logo et le nom de la marque, par la classe `CarBrandTableViewCell` héritant de `UITableViewCell`:
```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Cellule (TableViewCell) personnalisée
    let cell = tableView.dequeueReusableCell(withIdentifier: "carBrandCell", for: indexPath) as! CarBrandTableViewCell
    cell.configuration(with: filteredCarBrands[indexPath.row])
    
    return cell
}
```

- Au clic sur la cellule, on déclenche la transition (segue) vers un autre `ViewController`, ici `CarViewController`. En réecrivant (`override`) la méthode `prepare()`, on fait passer les données de la cellule (de type `Car` contenant l'ensemble des modèles enregistrés de la marque) vers `CarViewController`.
```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "carModelSegue", sender: self)
}

// De la cellule, on transite vers le ViewController de la marque de la voiture avec les données de la cellule
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? CarViewController
    {
        // On vérifie que le contenu de l'article existe
        guard let index = listeMarquesVoitures.indexPathForSelectedRow?.row else
        {
            return
        }
    
        // On envoie au ViewController les données de la marque
        destination.car = filteredCarBrands[index]
        destination.imageName = filteredCarBrands[index].imageName
    }
}
```
