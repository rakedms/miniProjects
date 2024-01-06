const express = require('express');
const mongoose = require('mongoose');
const app = express();
const bodyParser = require('body-parser');
const server = app.listen(8000)
console.log(`Server is running in port ${server.address().port}`)

mongoose.connect('mongodb://127.0.0.1:27017/TasksList', {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      }).then(() => {
      console.log('Mongoose Connected');
      }).catch((e) => {
      console.error(`Mongoose Connection Error: ${e.message}`);
    });


    const Tasks = mongoose.model('Tasks', {
        name:String
    })

    app.use(express.json())
    app.set('view engine', 'ejs')
    app.use(bodyParser.urlencoded({ extended: true }));
    app.use(express.static('public'));

app.get('/', async (req,res)=>{
    const AllTasks = await Tasks.find();
    res.render('index', {AllTasks});
})


app.post('/addtasks',async (req,res)=>{
    const NewTask = req.body.TaskName;
    await Tasks.create({
        name : NewTask
    })
    console.log(`Tasks ${req.body.TaskName} Created`)
    res.redirect('/');    
})
