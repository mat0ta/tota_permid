const Discord = require('discord.js');
const client = new Discord.Client({ partials: ["MESSAGE", "USER", "REACTION"] });
const { token, prefix, logo, hex_color, community_name, role_access_id, database_host, database_user, database_password, database_base } = require('./config.json');
var mysql = require('mysql')

var con = mysql.createConnection({
    host: database_host,
    user: database_user,
    password: database_password,
    database: database_base
})
con.connect(function(err) {
    if (err) throw err;
    console.log("MySQL connected!")
})

function sendSuccsess(fromUser, code, type, amount, chnl, fromUser) {

    const MadePrivateEmbed = new Discord.MessageEmbed()
	.setColor(hex_color)
    .setTitle('The ID has been successfully checked.')
	.setAuthor(community_name + " Perm ID System", logo)
    chnl.send(MadePrivateEmbed);
}

function sendSuccsessC(fromUser, code, type, amount, chnl, fromUser) {

    const MadePrivateEmbed = new Discord.MessageEmbed()
	.setColor(hex_color)
    .addFields(
		{ name: 'Name:', value: code},
        { name: 'Perm ID:', value: type, inline: true },
	)
    chnl.send(MadePrivateEmbed);
}


function sendSuccsessL(fromUser, code, type, amount, chnl, fromUser) {

    const MadePrivateEmbed = new Discord.MessageEmbed()
	.setColor(hex_color)
    .addFields(
        { name: 'License:', value: amount, inline: true },
	)
    chnl.send(MadePrivateEmbed);
}

function sendSuccsessD(fromUser, code, type, amount, chnl, fromUser) {

    const MadePrivateEmbed = new Discord.MessageEmbed()
	.setColor(hex_color)
    .addFields(
        { name: 'Discord:', value: amount, inline: true },
	)
    chnl.send(MadePrivateEmbed);
}

function sendSuccsessA(fromUser, code, type, amount, chnl, fromUser) {

    const MadePrivateEmbed = new Discord.MessageEmbed()
	.setColor(hex_color)
    .addFields(
        { name: 'Steam:', value: amount, inline: true },
	)
	.setTimestamp()
	.setFooter('Made By MCNMATOTA#2277', logo);
    chnl.send(MadePrivateEmbed);
}

function sendusage(chnl) {
    const sendusage = new Discord.MessageEmbed()
	.setColor(hex_color)
	.setTitle('Usage: !checkid <ID>')
	.setAuthor(community_name + " Perm ID System", logo)
	.setTimestamp()
	.setFooter('Made By MCNMATOTA#2277', logo);
    chnl.send(sendusage);
}

client.on('ready', () => {
    console.log(community_name + "'s Perm ID BOT has been loaded.");
    console.log("Made By MCNMATOTA#2277");
});

client.on('message', async message => {
    if (message.author.bot) return;
    if (message.content.indexOf(prefix) !== 0) return;

    const args = message.content.slice(prefix.length).trim().split(/ +/g);
    const command = args.shift().toLowerCase();

    if (command == "checkid") {
        message.delete()
        if (!message.member.roles.cache.has(role_access_id)) return;
        const fromUser = message.author.username
        const type = args[0]
        if (type == undefined) return sendusage(message.channel);
        var code = "SELECT name FROM users WHERE `permid` = '" + type + "'";
        con.query(code, (err, resultc)=>{  
            if(err) throw err;
        let finalcode = resultc[0].name;
        sendSuccsess(fromUser, finalcode, type, finalcode, message.channel, fromUser)
        sendSuccsessC(fromUser, finalcode, type, finalcode, message.channel, fromUser)
    });
    var license = "SELECT license FROM users WHERE `permid` = '" + type + "'";
        con.query(license, (err, resultl)=>{  
            if(err) throw err;
            let finallicense = resultl[0].license;
            sendSuccsessL(fromUser, finallicense, type, finallicense, message.channel, fromUser)
    });
    var discord = "SELECT discord FROM users WHERE `permid` = '" + type + "'";
        con.query(discord, (err, resultd)=>{  
            if(err) throw err;
            let finaldiscord = resultd[0].discord;
            sendSuccsessD(fromUser, finaldiscord, type, finaldiscord, message.channel, fromUser)
    });
        var amount = "SELECT steam FROM users WHERE `permid` = '" + type + "'";
        con.query(amount, (err, resulta)=>{  
            if(err) throw err;
            let finalamount = resulta[0].steam;
            sendSuccsessA(fromUser, finalamount, type, finalamount, message.channel, fromUser)
    });
    // sendSuccsess(fromUser, finalcode, type, finalamount, message.channel, fromUser)
    }
    if(command == "usage") {
        message.delete()
        if (!message.member.roles.cache.has(role_access_id)) return;
        sendusage(message.channel)
    }
})

client.login(token);