# 1. Crear el método request que reciba una url y el api_key y devuelva el hash con los
# resultados. Concatenar la API Key en la siguiente url:
# https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=DEMO_KEY
# 2. Crear un método llamado buid_web_page que reciba el hash de respuesta con todos
# los datos y construya una página web. Se evaluará la página creada y tiene que tener
# este formato:
# <html>
# <head>
# </head>
# <body>
# <ul>
# <li><img src='.../398380645PRCLF0030000CC AM04010L1.PNG'></li>
# <li><img src='.../398381687EDR_F0030000CCAM05010M_.JPG'></li>
# </ul>
# </body>
# </html>
# 3. Pregunta bonus: Crear un método photos_count que reciba el hash de respuesta y
# devuelva un nuevo hash con el nombre de la cámara y la cantidad de fotos.

require "uri"
require "net/http"
require 'json'

# Pregunta 1
def request(url_request) # metodo request que recibe una URL
  #puts url_request
  url = URI(url_request)
  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true
  request = Net::HTTP::Get.new(url)#recurso get
  response = https.request(request) 
  results = JSON.parse(response.read_body)#parsing hash
end

# Pregunta2
def buid_web_page(hash_web)
  photos_html = []
  hash_web["photos"].count.times do |i| #se itera para rescatar imagenes
    photos_html << hash_web["photos"][i]["img_src"] # se crea arreglo con imagenes
  end 
  #modulo para crecion de pagina con estructura solicitada revisada desde google
  contents = <<~HTML
  <!DOCTYPE html>
  <html lang="en">
  <head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <meta name="Description" content="Enter your description here"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.1.0/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link rel="stylesheet" href="assets/css/style.css">
  <title>Prueba_Modulo6_YEA</title>
  </head>
    <body>
      <section class="container text-center">
        <h1>Fotos API Nasa</h1>
        <ul>
          #{photos_html[0..9].map{|e|"\t\t\t\t""<li><img class=""img-fluid"" src=\"#{e}\"></li>\n"}.join}
        </ul>
      </section>
    </body>
  </html>
  HTML
  File.write("output.html",contents)#crea archivo de salida html
end

# Pregunta 3
def photos_count(hash) # se llama al metodo con hash resultante de metodo request asignado a variable data
  camera1=[] # se crea arreglo para nombres de la camara
  hash["photos"].count.times do |i| #se itera para rescatar nombre de camara, hash de 1 llave y un arreglo de hashs
    camera1 << hash["photos"][i]["camera"]["name"] # se crea arreglo con nombres de camaras
end
  new_hash_count=camera1.group_by {|x| x} # se agrupan los datos del hash con el areglo de los nombres de camara retorna llave => [areglo de camaras]]
  #Luego reemplazamos el valor por la cuenta y nos entrega hash
  new_hash_count.each do |k,v|
    new_hash_count[k] = v.count
  end
  new_hash_count #retorna hash con camara y cant de fotos
end

# llamada a metodo request con url api nasa y key propio retornado de registro en pag nasa, metodo request retorna un hash 1 llave con arreglo de hash de 856 
api_key=ARGV[0] #rescata parametro de api_key ingresado por usuario
data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key="+"#{api_key}") #llama al metodo request y asigna resultado a varible data
#print "#{data} \n"
# puts data.class

# Llamada a metodo buid_web_page que crea archivo output.html con la estructura e imagenes
data1=buid_web_page(data)

# Llamada a metodo photos_count con hash resultante de metodo request
data2 = photos_count(data)
#print "#{data2} \n" 



