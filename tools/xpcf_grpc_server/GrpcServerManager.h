/**
 * @copyright Copyright (c) 2019 B-com http://www.b-com.com/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @author Loïc Touraine
 *
 * @file
 * @brief description of file
 * @date 2019-11-15
 */

#ifndef GRPCPROTOGENERATOR_H
#define GRPCPROTOGENERATOR_H
#include <xpcf/component/ConfigurableBase.h>
#include <xpcf/remoting/IGrpcServerManager.h>

namespace org { namespace bcom { namespace xpcf {

class GrpcServerManager : public ConfigurableBase, virtual public IGrpcServerManager
{
public:
    GrpcServerManager();
    ~GrpcServerManager() override;
    void unloadComponent () override;
    grpc::ServerBuilder & registerService(grpc::Service * service) override;
    grpc::ServerBuilder & registerService(const grpc::string & host, grpc::Service * service) override;
    grpc::ServerBuilder & registerService(SRef<IGrpcService> service) override;
    grpc::ServerBuilder & registerService(const grpc::string & host, SRef<IGrpcService> service) override;
    void runServer() override;
    XPCFErrorCode onConfigured() override;

private:
    grpc::ServerBuilder builder;
    std::string m_serverAddress;

};




template <> struct org::bcom::xpcf::ComponentTraits<GrpcServerManager>
{
    static constexpr const char * UUID = "{7FD1E545-F2F5-44A0-B30E-51B477455077}";
    static constexpr const char * NAME = "GrpcServerManager";
    static constexpr const char * DESCRIPTION = "GrpcServerManager implements IGrpcServerManager interface";
};

}}}

#endif // GRPCPROTOGENERATOR_H
