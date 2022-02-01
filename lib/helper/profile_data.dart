
class Profile{
  String? role,firstname,bio,website,profilepic,uid,signin_method,lastname,email,gender,city,state,zipcode,country,longitude,latitude;

  Profile( this.email,this.uid,this.firstname, this.lastname, this.gender, this.city,
      this.state, this.zipcode, this.country, this.longitude, this.latitude,this.bio,this.website,this.profilepic);

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email':email,
      'gender':gender,
      'city':city,
      'state':state,
      'zipcode':zipcode,
      'country':country,
      'longitude':longitude,
      'latitude':latitude,
      'uid':uid,
      'bio':bio,
      'website':website,
      'profilepic':profilepic,
    };
  }


}