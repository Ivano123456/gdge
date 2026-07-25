Locales['en'] = {

      -- TextUI

    ['bossmenu'] = {
        text = '[E] Open Boss Menu',
        color = 'darkblue',
        side = 'right'
    },

    ['dutymenu'] = {
        text = '[E] Open Duty Menu',
        color = 'darkblue',
        side = 'right'
    },

    -- Error Notifications

    ['no_money'] = {
        title = "Boss Menu",
        text = "You do not have enough money to deposit on the society",
        time = 5000,
        type = 'error'
    },

    ['no_money_society'] = {
        title = "Boss Menu",
        text = "You do not have enough money on the society",
        time = 5000,
        type = 'error'
    },

    ['target_fired_employee'] = {
        title = "Boss Menu",
        text = "You got fired from ${job}",
        time = 5000,
        type = 'error'
    },

    ['near_error'] = {
        title = 'Boss Menu',
        text = 'There is no one nearby',
        type = 'error',
        time = 5000,
    },

    ['same_job'] = {
        title = 'Boss Menu',
        text = '${player} is already on ${job}',
        type = 'error',
        time = 5000,
    },

    ['cant_edit_chief'] = {
        title = 'Boss Menu',
        text = 'You can\'t edit the grade of a chief',
        type = 'error',
        time = 5000,
    },

    ['cant_edit_self'] = {
        title = 'Boss Menu',
        text = 'You can\'t edit your own grade',
        type = 'error',
        time = 5000,
    },

    ['cant_fire_chief'] = {
        title = 'Boss Menu',
        text = 'You can\'t fire  a chief',
        type = 'error',
        time = 5000,
    },

    ['cant_fire_self'] = {
        title = 'Boss Menu',
        text = 'You can\'t fire yourself here',
        type = 'error',
        time = 5000,
    },

    ['duty_ended'] = {
        title = "Boss Menu",
        text = "You are now off duty",
        time = 5000,
        type = 'error'
    },

    ['cant_open_menu'] = {
        title = "Boss Menu",
        text = "You can't open the menu because you are not the boss",
        time = 5000,
        type = 'error'
    },

    -- Success Notifications

    ['deposited'] = {
        title = "Boss Menu",
        text = "You have deposited ${money}" ..Config.Currency.." in the ${job} society",
        time = 5000,
        type = 'success'
    },
    
    ['withdrawn'] = {
        title = "Boss Menu",
        text = "You have withdrawn ${money}" ..Config.Currency.." from the ${job} society",
        time = 5000,
        type = 'success'
    },

    ['edited_employee'] = {
        title = "Boss Menu",
        text = "You have edited the grade from ${player} to ${grade}",
        time = 5000,
        type = 'success'
    },

    ['target_edited_employee'] = {
        title = "Boss Menu",
        text = "Your grade has been edited to ${grade}",
        time = 5000,
        type = 'success'
    },

    ['fired_employee'] = {
        title = "Boss Menu",
        text = "You fired ${player} from ${job}",
        time = 5000,
        type = 'success'
    },

    ['hired_employee'] = {
        title = "Boss Menu",
        text = "You hired ${player} to ${job}",
        time = 5000,
        type = 'success'
    },

    ['target_hired_employee'] = {
        title = "Boss Menu",
        text = "You got hired to ${job}",
        time = 5000,
        type = 'success'
    },

    ['duty_started'] = {
        title = "Boss Menu",
        text = "You are now on duty",
        time = 5000,
        type = 'success'
    },

    ['bonus_given'] = {
        title = "Boss Menu",
        text = "You have given a bonus of ${money}" ..Config.Currency.." to ${player}",
        time = 5000,
        type = 'success'
    },

    ['bonus_received'] = {
        title = "Boss Menu",
        text = "You have received a bonus of ${money}" ..Config.Currency.." from ${job}",
        time = 5000,
        type = 'success'
    },

    -- Warning Notifications

    ['no_society'] = {
        title = "Boss Menu",
        text = "Society information not found, make sure that your society system is set in the config and verify that the society exists in the database",
        time = 5000,
        type = 'warning'
    },

    -- Translations

    ['translations'] = {
        overview = "Overview",
        employees = "Employees",
        grades = "Grades",
        storage = "Storage",
        outfits = "Outfits",
        logout = "Logout",
        menu = "Menu",
        finances = "Finances",
        balance = "Balance",
        deposit = "Deposit",
        withdraw = "Withdraw",
        mostActiveEmployees = "Most Active Employees",
        grade = "Grade",
        lastweek = "Last Week",
        depositmoney = "Deposit Money",
        withdrawmoney = "Withdraw Money",
        amount = "Amount",
        hireEmployee = "Hire Employee",
        fireemployee = "Fire Employee",
        selectperson = "Select a Person",
        hire = "Hire",
        edit = "Edit",
        actions = "Actions",
        name = "Name",
        save = "Save",
        editemployee = "Edit Employee",
        cancel = "Cancel",
        fire = "Fire",
        wanttofire = "Do you want to fire",
        selectuser = "Select a user",
        wanttobehired = "Do you want to be hired by",
        helpmenucommand = "Open the boss menu",
        helpdutycommand = "Open the duty menu",
        goonduty = "Go on duty",
        gooffduty = "Go off duty",
        openbossmenu = "Open boss menu",
        opendutymenu = "Open duty menu",
        online = "Online",
        offline = "Offline",
        performance = "Performance",
        status = "Status",
        total = "Total",
        lastsevendays = "Last 7 days",
        hours = "Hours",
        duty = "Duty",
        monday = "Monday",
        tuesday = "Tuesday",
        wednesday = "Wednesday",
        thursday = "Thursday",
        friday = "Friday",
        saturday = "Saturday",
        sunday = "Sunday",
        today = "Today",
        rank = "Rank",
        salary = "Salary",
        delete = "Delete",
        wanttodelete = "Do you want to delete the",
        recruit = "Recruit",
        lastonline = "Last Online",
        noinfo = "No Info",
        givebonus = "Give Bonus",
        confirm = "Confirm",
        none = "None",
        nogangaffiliation = "No Gang Affiliation",
        unemployed = "unemployed",
        unemployedLabel = "Unemployed",
        nodata = "No Data",
        noinfoavailable = "No Info Available",
        bonus = "Bonus - ",
        peerBossActionsLocked = "Between bosses: changing rank and firing are not available for this employee.",
    },
}