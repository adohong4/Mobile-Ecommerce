'use strict';

const AccountService = require('../../services/admin/account.service');
const { OK, CREATED } = require('../../core/success.response');

class AccountController {
    getAccounts = async (req, res, next) => {
        try {
            const account = await AccountService.getAccounts();
            new OK({
                message: 'Hiện toàn bộ tài khoản',
                metadata: account
            }).send(res);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new AccountController();