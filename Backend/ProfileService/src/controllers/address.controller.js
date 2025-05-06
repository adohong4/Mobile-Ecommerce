'use strict';

const AddressService = require('../services/address.service');
const { OK, CREATED } = require('../core/success.response');

class AddressController {
    async createAddress(req, res, next) {
        try {
            const address = await AddressService.createAddress(req, res);
            new CREATED({
                message: 'Create address',
                metadata: { address },
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getListAddress(req, res, next) {
        try {
            const addresses = await AddressService.getListAddress(req, res);
            new OK({
                message: 'Get list address',
                metadata: addresses.metadata,
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async deleteAddress(req, res, next) {
        try {
            await AddressService.deleteAddress(req, res);
            new OK({
                message: 'Delete address',
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

}

module.exports = new AddressController();