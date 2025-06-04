'use strict';

const identityModel = require("../models/identity.model");
const profileModel = require("../models/profile.model");
const bcrypt = require('bcrypt');
const validator = require('validator');
const { BadRequestError, ConflictRequestError, AuthFailureError, ForbiddenError } = require("../core/error.response");
const { getInfoData } = require("../utils/index");
const { createToken } = require("../middleware/authUtils")

class IdentityService {
    static register = async (req, res) => {
        try {
            const { username, email, password, role } = req.body;

            const existEmail = await identityModel.findOne({ email });
            if (existEmail) {
                throw new ConflictRequestError(`${email} đã được đăng ký`);
            }

            if (!validator.isEmail(email)) {
                throw new BadRequestError('Không đúng định dạng email');
            }

            if (password.length < 8) {
                throw new BadRequestError('Mật khẩu quá yếu, cần ít nhất 8 ký tự')
            }

            const salt = await bcrypt.genSalt(10)
            const hashedPassword = await bcrypt.hash(password, salt);

            const newUser = await identityModel.create({
                username: username,
                email: email,
                password: password,
                hashedPassword: hashedPassword,
            })

            // await profileModel.create({
            //     userId: newUser._id,
            // });

            const tokenPayload = {
                userId: newUser._id,
                email: newUser.email,
                role: newUser.role,
            };

            const token = createToken(tokenPayload, req.res);

            if (newUser) {
                return {
                    metadata: {
                        user: getInfoData({ fileds: ['_id', 'username', 'email', 'role'], object: newUser }),
                        token
                    }
                }
            }
            return null;
        } catch (error) {
            throw error;
        }
    }

    static login = async (req, res) => {
        try {
            const { email, password, hashedPassword } = req.body;
            const user = await identityModel.findOne({ email });

            if (!user) {
                throw new BadRequestError("Tài khoản không tồn tại");
            }

            const isMath = await bcrypt.compare(password, user.hashedPassword);

            if (!isMath) {
                throw new BadRequestError("Mật khẩu không chính xác");
            }

            const { _id: userId } = user;
            const role = user.role;
            const token = createToken({ userId, email, role }, req.res);

            return {
                user: {
                    id: user._id,
                    email: user.email,
                    role: user.role,
                },
                token,
            };
        } catch (error) {
            throw error;
        }
    }

    static logout = async (res) => {
        try {
            res.cookie("jwt", "", { maxAge: 0 });
        } catch (error) {
            throw error;
        }
    }
}

module.exports = IdentityService;