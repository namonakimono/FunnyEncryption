const fs = require('fs');
const exec = require('child_process').exec;

function enc(req, res, next) {
  const realKey = req.body.realKey;
  const realText = req.body.realText;
  const fakeKey = req.body.fakeKey;
  const fakeText = req.body.fakeText;
  const randomDir = req.body.randomDir;

  exec("mkdir -p /tmp/" + randomDir, function(err){
    console.log(randomDir);
    if (err){console.log(err); console.log("Folder exists. It does not matter.")}
    var realFile = "/tmp/" + randomDir + "/real.txt";
    var fakeFile = "/tmp/" + randomDir + "/fake.txt";
    var encryptedFile = "/tmp/" + randomDir + "/encrypted.txt";

    fs.writeFileSync(realFile, realText, 'utf8');
    fs.writeFileSync(fakeFile, fakeText, 'utf8');

    exec("FunnyEnc " + "enc " +  realKey + " " + fakeKey + " " + realFile  + " " + fakeFile + " " + encryptedFile, function(err){
      if(err){console.log(err); res.send({status: "fail", msg: err.toString() });}
      else {
          console.log("Text encrypted.");
          var encryptedText = fs.readFileSync(encryptedFile, 'utf8');
          res.send({status: "success", encryptedText: encryptedText});
      }
    });
  });
}


module.exports = enc;
