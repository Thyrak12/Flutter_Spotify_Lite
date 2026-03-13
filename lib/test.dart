class Dog {
  final String breed;

  Dog._(this.breed); // private constructor

  factory Dog.husky() {
    print("Creating a husky");
    return Dog._("Husky"); // could add logic here
  }

  factory Dog.golden() {
    print("Creating a golden retriever");
    return Dog._("Golden Retriever");
  }
}

void main() {
  Dog d1 = Dog.husky(); // create a Husky instance
  print(d1.hashCode);

  d1 = Dog.golden(); // reassign to a new Golden Retriever instance
  print(d1.hashCode);


}
