class Forum {
  final String firstName, lastName, title, department, subCategory, desc;
  String? profilePic, image;
  Forum(this.firstName, this.lastName, this.title, this.department,
      this.subCategory, this.desc, this.profilePic, this.image);

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
