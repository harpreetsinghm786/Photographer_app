
class Contract{
  String? contractid, userid,photographerid, massage,status;
  DateTime? bookfrom, bookto;
  var totalPrice;


  Contract(this.contractid, this.userid, this.photographerid, this.massage,
      this.bookfrom, this.bookto,this.totalPrice,this.status);

  Map<String, dynamic> toMap() {
    return {
      "contractid":this.contractid,
      "userid":this.userid,
      "photographerid":this.photographerid,
      "massage":this.massage,
      "bookfrom":this.bookfrom,
      "bookto": this.bookto,
      "totalPrice":this.totalPrice,
      "status":this.status,
    };
  }


}