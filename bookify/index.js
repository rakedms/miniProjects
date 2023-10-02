const express= require("express")
const app=express()
const bodyParser=require("body-parser")
app.use(bodyParser.json())
books=[{
    "id":1,
    "name":"Rework",
    "pages":150,
    "authour":"xxx"
},
{
    "id":2,
    "name":"Friends",
    "pages":260,
    "authour":"xxx"
},
{
    "id":3,
    "name":"Rich",
    "pages":400,
    "authour":"xxx"
},
{
    "id":4,
    "name":"DAD",
    "pages":180,
    "authour":"xxx"
},
{
    "id":5,
    "name":"Mind",
    "pages":230,
    "authour":"xxx"
}]
app.get("/books",(req,res)=>{
    res.json({AllBooks:books})
})

app.get("/books/:id",(req,res)=>{
    const id=req.params.id
    const book=books.find((b)=>b.id==id)
    res.json({book})
})

app.post("/books/",(req,res)=>{
    const newBook=req.body
    books.push(newBook)
    return res.json({"status":"success"})
}) 

app.delete("/books/:id",(req,res)=>{
    const id=req.params.id
    books=books.filter((e)=>e.id!=id)
    return res.json({"status":"deleted"})
})
app.listen(8000,()=>{console.log("Server started")})
