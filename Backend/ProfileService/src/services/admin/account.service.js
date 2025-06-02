'use strict';

const accountModel = require('../../models/profile.model');
const { BadRequestError, AuthFailureError } = require("../../core/error.response");

class AccountService {

    static getAccounts = async () => {
        try {
            const account = await accountModel.find()
                .select('userId fullName phoneNumber')
                .sort({ createdAt: -1 });
            return account;
        } catch (error) {
            throw error;
        }
    }

}

module.exports = AccountService;