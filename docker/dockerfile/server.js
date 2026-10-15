const http = require('http');

const asciiArt = `
███████╗███╗   ██╗████████╗███████╗██████╗ 
██╔════╝████╗  ██║╚══██╔══╝██╔════╝██╔══██╗
█████╗  ██╔██╗ ██║   ██║   █████╗  ██████╔╝
██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗
███████╗██║ ╚████║   ██║   ███████╗██║  ██║
╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
                                          
        Enter the Matrix...
`;

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end(asciiArt);
});

const PORT = 8080;
server.listen(PORT, () => {
    console.log(`Servidor en ejecución en http://localhost:${PORT}`);
});
