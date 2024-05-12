class POI {
  final String firstName, lastName, title, department, subCategory, desc;
  String? profilePic, image;
  final int aval;

  POI(this.firstName, this.lastName, this.title, this.department,
      this.subCategory, this.desc, this.aval, this.profilePic, this.image);

  String getFirstName() {
    return firstName;
  }

  String getLastName() {
    return lastName;
  }

  String getTitle() {
    return title;
  }

  String getDepartment() {
    return department;
  }

  String getSubCategory() {
    return subCategory;
  }

  String getDescription() {
    return desc;
  }

  int getAval() {
    return aval;
  }

  String? getProfilePic() {
    return profilePic;
  }

  String? getImage() {
    return image;
  }

  void setProfilePic(String? pic) {
    profilePic = pic;
  }

  void setImage(String? img) {
    image = img;
  }
}
