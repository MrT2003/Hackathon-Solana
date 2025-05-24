export class User{
    constructor(uid,email,createdAt,isAdmin,name, updatedAt){
        this.uid = uid;
        this.email = email;
        this.name = name? name : "Anonymous";
        this.createdAt = createdAt;
        this.updatedAt = updatedAt? updatedAt : createdAt;
        this.isAdmin = isAdmin? isAdmin : false;
    }

    toJSON(){
        return {
            uid: this.uid,
            email: this.email,
            name: this.name,
            createdAt: this.createdAt,
            updatedAt: this.updatedAt,
            isAdmin: this.isAdmin
        }
    }
}