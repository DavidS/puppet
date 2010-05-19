Puppet::Type.type(:user).provide :win32 do
    desc "User management for Windows."
    def exists?
        false
    end
end
