Locales['pt'] = {

      -- TextUI

    ['bossmenu'] = {
        text = '[E] Abrir Menu do Chefe',
        color = 'darkblue',
        side = 'right'
    },

    ['dutymenu'] = {
        text = '[E] Abrir Menu de Serviço',
        color = 'darkblue',
        side = 'right'
    },

    -- Error Notifications

    ['no_money'] = {
        title = "Boss Menu",
        text = "Não tens dinheiro suficiente para depositar na empresa",
        time = 5000,
        type = 'error'
    },

    ['no_money_society'] = {
        title = "Boss Menu",
        text = "Não tens dinheiro suficiente na empresa",
        time = 5000,
        type = 'error'
    },

    ['target_fired_employee'] = {
        title = "Boss Menu",
        text = "Foste despedido de ${job}",
        time = 5000,
        type = 'error'
    },

    ['near_error'] = {
        title = 'Boss Menu',
        text = 'Não há ninguém por perto',
        type = 'error',
        time = 5000,
    },

    ['same_job'] = {
        title = 'Boss Menu',
        text = '${player} já está no trabalho de ${job}',
        type = 'error',
        time = 5000,
    },

    ['cant_edit_chief'] = {
        title = 'Boss Menu',
        text = 'Não podes editar o cargo de um chefe',
        type = 'error',
        time = 5000,
    },

    ['cant_edit_self'] = {
        title = 'Boss Menu',
        text = 'Não podes editar o teu próprio cargo',
        type = 'error',
        time = 5000,
    },

    ['cant_fire_chief'] = {
        title = 'Boss Menu',
        text = 'Não podes despedir um chefe',
        type = 'error',
        time = 5000,
    },

    ['cant_fire_self'] = {
        title = 'Boss Menu',
        text = 'Não podes despedir-te a ti mesmo',
        type = 'error',
        time = 5000,
    },

    ['duty_ended'] = {
        title = "Boss Menu",
        text = "Estás agora fora de serviço",
        time = 5000,
        type = 'error'
    },

    ['cant_open_menu'] = {
        title = "Boss Menu",
        text = "Não podes abrir o menu porque não és o chefe",
        time = 5000,
        type = 'error'
    },

    -- Success Notifications

    ['deposited'] = {
        title = "Boss Menu",
        text = "Depositaste ${money}" ..Config.Currency.." em ${job}",
        time = 5000,
        type = 'success'
    },
    
    ['withdrawn'] = {
        title = "Boss Menu",
        text = "Levantaste ${money}" ..Config.Currency.." de ${job}",
        time = 5000,
        type = 'success'
    },

    ['edited_employee'] = {
        title = "Boss Menu",
        text = "Tu editaste o cargo de ${player} para ${grade}",
        time = 5000,
        type = 'success'
    },

    ['target_edited_employee'] = {
        title = "Boss Menu",
        text = "O teu cargo foi alterado para ${grade}",
        time = 5000,
        type = 'success'
    },

    ['fired_employee'] = {
        title = "Boss Menu",
        text = "Despediste ${player} de ${job}",
        time = 5000,
        type = 'success'
    },

    ['hired_employee'] = {
        title = "Boss Menu",
        text = "Contrataste ${player} para ${job}",
        time = 5000,
        type = 'success'
    },

    ['target_hired_employee'] = {
        title = "Boss Menu",
        text = "Foste contratado para ${job}",
        time = 5000,
        type = 'success'
    },

    ['duty_started'] = {
        title = "Boss Menu",
        text = "Estás agora de serviço",
        time = 5000,
        type = 'success'
    },

    ['bonus_given'] = {
        title = "Boss Menu",
        text = "Deste um bónus de ${money}" ..Config.Currency.." a ${player}",
        time = 5000,
        type = 'success'
    },

    ['bonus_received'] = {
        title = "Boss Menu",
        text = "Recebeste um bónus de ${money}" ..Config.Currency.." de ${job}",
        time = 5000,
        type = 'success'
    },

    -- Warning Notifications

    ['no_society'] = {
        title = "Boss Menu",
        text = "Informação da sociedade não encontrada, vê se a sociedade existe na base de dados",
        time = 5000,
        type = 'warning'
    },

    -- Translations

    ['translations'] = {
        overview = "Geral",
        employees = "Empregados",
        grades = "Cargos",
        storage = "Armazém",
        outfits = "Outfits",
        logout = "Sair",
        menu = "Menu",
        finances = "Finanças",
        balance = "Dinheiro",
        deposit = "Depositar",
        withdraw = "Levantar",
        mostActiveEmployees = "Empregados mais ativos",
        grade = "Cargo",
        lastweek = "Última semana",
        depositmoney = "Depositar dinheiro",
        withdrawmoney = "Levantar Dinheiro",
        amount = "Quantia",
        hireEmployee = "Contratar Empregado",
        fireemployee = "Despedir Empregado",
        selectperson = "Selecionar Jogador",
        hire = "Contratar",
        edit = "Editar",
        actions = "Ações",
        name = "None",
        save = "Guardar",
        editemployee = "Editar empregado",
        cancel = "Cancelar",
        fire = "Despedir",
        wanttofire = "Queres despedir",
        selectuser = "Selecionar um jogador",
        wanttobehired = "Queres ser contratado por",
        helpmenucommand = "Abrir o menu de chefe",
        helpdutycommand = "Abrir o menu de serviço",
        goonduty = "Entrar de serviço",
        gooffduty = "Sair de serviço",
        openbossmenu = "Abrir menu do chefe",
        opendutymenu = "Abrir menu de serviço",
        online = "Online",
        offline = "Offline",
        performance = "Performance",
        status = "Estado",
        total = "Total",
        lastsevendays = "Últimos 7 dias",
        hours = "Horas",
        duty = "Serviço",
        monday = "Segunda-feira",
        tuesday = "Terça-feira",
        wednesday = "Quarta-feira",
        thursday = "Quinta-feira",
        friday = "Sexta-feira",
        saturday = "Sábado",
        sunday = "Domingo",
        today = "Hoje",
        rank = "Rank",
        salary = "Salário",
        delete = "Delete",
        wanttodelete = "Queres apagar o",
        recruit = "Recruta",
        lastonline = "Última vez online",
        noinfo = "Sem Info",
        givebonus = "Dar Bónus",
        confirm = "Confirmar",
        none = "Nenhum",
        nogangaffiliation = "Sem Afiliação a Gangue",
        unemployed = "unemployed",
        unemployedLabel = "Desempregado",
        nodata = "Sem Data",
        noinfoavailable = "Sem Info Disponível",
        bonus = "Bónus - ",
        peerBossActionsLocked = "Entre chefes: não podes alterar o cargo nem expulsar este funcionário.",
    },
}