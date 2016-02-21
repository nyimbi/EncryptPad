//**********************************************************************************
//EncryptPad Copyright 2016 Evgeny Pokhilko 
//<http://www.evpo.net/encryptpad>
//
//This file is part of EncryptPad
//
//EncryptPad is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 2 of the License, or
//(at your option) any later version.
//
//EncryptPad is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with EncryptPad.  If not, see <http://www.gnu.org/licenses/>.
//**********************************************************************************
#include "curl_loader.h"
#include "subprocesses.hpp"

using namespace stlplus;

namespace {
    class CurlSubprocess : public subprocess
    {
    public:
        const std::string &get_output()
        {
            return output;
        }
    protected:
        std::string output;
        virtual bool callback()
        {
            while(read_stdout(output)>=0);
            return true;
        }
    };
}

namespace EncryptPad
{
    PacketResult LoadKeyFromFileThroughCurl(const std::string& file_name, const std::string &libcurl_path, std::string &key)
    {
       arg_vector arg_v;
       arg_v += std::string(libcurl_path);
       arg_v += std::string(file_name);
       CurlSubprocess sub_proc;
       bool result = sub_proc.spawn(libcurl_path, arg_v, false, true, false);
       if(!result)
       {
           switch(sub_proc.error_number())
           {
           case 2:
           case 3:
               return PacketResult::CurlIsNotFound;
           default:
               return PacketResult::IOErrorKeyFile;
           }
       }

       if(sub_proc.get_output().length() == 0)
           return PacketResult::IOErrorKeyFile;
       if(sub_proc.exit_status() != 0)
           return PacketResult::CurlExitNonZero;

       key = sub_proc.get_output();
       // key = Botan::OctetString(Botan::base64_decode(sub_proc.get_output()));
       return PacketResult::Success;
    }
}