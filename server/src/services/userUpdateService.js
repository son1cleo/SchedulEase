const bcrypt = require('bcryptjs');
const User = require("../models/User");

class UserBuilder {
    constructor(user) {
        this.user = user;
    }

    setFirstName(first_name) {
        if (first_name) this.user.first_name = first_name;
        return this;
    }

    setLastName(last_name) {
        if (last_name) this.user.last_name = last_name;
        return this;
    }

    setPhoneNumber(phone_number) {
        if (phone_number) this.user.phone_number = phone_number;
        return this;
    }

    async setPassword(currentPassword, newPassword) {
        if (newPassword) {
            // Verify the current password
            const isMatch = await bcrypt.compare(currentPassword, this.user.password);
            if (!isMatch) {
                throw new Error("Current password is incorrect");
            }

            this.user.password = newPassword;
        }
        return this;
    }

    build() {
        return this.user;
    }
}

const updateUser = async (userId, updatedFields) => {
    const user = await User.findById(userId);
    if (!user) throw new Error("User not found");

    const builder = new UserBuilder(user);
    builder
        .setFirstName(updatedFields.first_name)
        .setLastName(updatedFields.last_name)
        .setPhoneNumber(updatedFields.phone_number);

    // If password update is requested, validate and hash it
    if (updatedFields.current_password && updatedFields.password) {
        await builder.setPassword(updatedFields.current_password, updatedFields.password);
    }

    const updatedUser = builder.build();
    await updatedUser.save();

    return { message: "User updated successfully", user: updatedUser };
};

module.exports = { updateUser };
