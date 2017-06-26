local json = require("json")

local webService = {}

local composer = require("composer")

local toast = require("plugin.toast")





-- Rest de Cadastro de Motorista
--================================================================================================================================================================
local function eventoCadastrarMotorista(event)
    
    if not event.isError then
        local response = json.decode(event.response)
        

		if event.status == 200 then
			composer.gotoScene("TelaLogin")
			toast.show("Cadastro realizado com sucesso!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
		
		elseif event.status == 422 then
			
			toast.show("CPF já cadastrado!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  

		else
			print(event.response)
        	print(event.status)
        	print("erro interno no servidor")
		end

    else

    	toast.show("Você não está conectado a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})

    end
    return
end



function webService:cadastrarMotorista(motorista)

	local headers = {}

	headers["Content-Type"] = "application/json"

	local motoristaJson = json.encode(motorista)

	local params = {}

	params.headers = headers

	params.body = motoristaJson

	network.request("http://localhost:8084/TesteZonaAzul/rest/motorista/salvar", "POST", eventoCadastrarMotorista, params)

end
--================================================================================================================================================================



-- Rest de Logar o Motorista
--================================================================================================================================================================
local function eventoLogarMotorista(event)
	if not event.isError then

		local response = json.decode(event.response)
		
		if event.status == 200 then
			
			local motoristaJson = json.decode(event.response)
			motoristaLogado = motoristaJson
			composer.gotoScene("TelaMotoristaInicial")
			
		elseif event.status == 401 then
			
			toast.show("Não foi possivel fazer login, CPF ou senha inválidos!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  

		else
			print(event.response)
        	print(event.status)
        	print("erro interno no servidor")
		end
		
	else
		toast.show("Você não está conectado a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
	end
	return 
end

function webService:logarMotorista(cpf,senha)

	local login = {}

	login.cpf = cpf
	login.senha = senha

	local headers = {}

	headers["Content-Type"] = "application/json"

	local motoristaLogin = json.encode(login)

	local params = {}
	
	params.headers = headers

	params.body = motoristaLogin

	network.request("http://localhost:8084/TesteZonaAzul/rest/motorista/login", "POST", eventoLogarMotorista, params)

end
--================================================================================================================================================================


--Rest de compra de cartão
--================================================================================================================================================================
local function eventoCompraCartao(event)
	if not event.isError then

		local response = json.decode(event.response)
		
		if event.status == 200 then
			
			print("retornouOk")

		elseif event.status == 401 then

			toast.show("Senha invalida", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  

		else
			print(event.response)
        	print(event.status)
        	print("erro interno no servidor")
		end
		
	else
		toast.show("Você não está conectado a internet!", {duration = 'short', gravity = 'TopCenter', offset = {0, display.contentHeight/10 *9.8}})  
	end
	return 
end

function webService:compraCartao(motorista,placa)

	local headers = {}

	headers["Content-Type"] = "application/json"

	
	local params = {}
	
	params.headers = headers

	local motoristaPlaca = motorista

	motoristaPlaca.numeros = placa.numeros
	motoristaPlaca.letras = placa.letras

	local dados = motoristaPlaca




	params.body =  json.encode(dados)

	
	print(params.body)
	network.request("http://localhost:8084/TesteZonaAzul/rest/cartaozonaazul/comprar", "POST", eventoCompraCartao, params)

end
--================================================================================================================================================================

return webService