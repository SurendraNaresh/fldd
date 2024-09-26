void main(){
// Creating list
  var myList = [20, 15, 37, 23, 60, 50, 20];
  // Item to be found
  int searchItem = 73;
  // Stores the index in variable found
  int found =  myList.indexOf(searchItem);

  if (found != -1) {
    print("$searchItem is found at index $found");
  } else {
    print("$searchItem is not present in the list");
  }
}