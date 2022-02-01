class Newpost{

   String url, caption, uid, postid;
   DateTime dateTime;

   Newpost(this.url, this.caption, this.uid, this.postid,this.dateTime);

   Map<String, dynamic> toMap() {
     return {
        "url":this.url,
        "caption":this.caption,
        "uid":this.uid,
        "postid":postid,
        "date":dateTime,
     };
   }
}