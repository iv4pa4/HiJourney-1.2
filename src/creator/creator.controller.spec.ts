// import { Test, TestingModule } from '@nestjs/testing';
// import { CreatorController } from './creator.controller';
// import { CreatorService } from './creator.service';
// import { Creator } from './creator.entity';
// import { Pagination, IPaginationMeta } from 'nestjs-typeorm-paginate';

// jest.mock('./creator.service');

// describe('CreatorController', () => {
//   let controller: CreatorController;
//   let creatorService: CreatorService;

//   beforeEach(async () => {
//     const module: TestingModule = await Test.createTestingModule({
//       controllers: [CreatorController],
//       providers: [
//         {
//           provide: CreatorService,
//           useValue: creatorService, 
//         },
//       ],
//     }).compile();

//     controller = module.get<CreatorController>(CreatorController);
//     creatorService = module.get<CreatorService>(CreatorService);
//   });

//   it('should be defined', () => {
//     expect(controller).toBeDefined();
//   });

//   it('should get all creators', async () => {
//     const creators: Creator[] = [{ id: 1, username: 'Creator 1', email: 'Email 1', password: 'Password 1' }];

 
//     const pagination: Pagination<Creator, IPaginationMeta> = {
//         items: creators,
//         links: {},
//         meta: { itemCount: creators.length, totalItems: creators.length, itemsPerPage: 10, totalPages: 1, currentPage: 1 },
//     };

//     jest.spyOn(creatorService, 'findAll').mockResolvedValue(pagination);
//     expect(await controller.findAll({})).toBe(pagination);
//   });

//   it('should get a single creator', async () => {
//     const creatorId = 1;
//     const creator: Creator = { id: creatorId, username: 'Creator 1', email: 'email 1', password: ' password1'  };
//     jest.spyOn(creatorService, 'getSingleCreator').mockResolvedValue(creator);
//     expect(await controller.getCreator(creatorId.toString())).toBe(creator);
//   });

//   it('should create a new creator', async () => {
//     const creatorDto = { username: 'New Creator', email: 'New email', password: 'New password' };
//     const createdCreator: Creator = { id: 1, ...creatorDto };
//     jest.spyOn(creatorService, 'create').mockResolvedValue(createdCreator);
//     expect(await controller.createCreator(creatorDto)).toBe(createdCreator);
//   });

//   it('should update a creator', async () => {
//     const creatorId = 1;
//     const creatorDto = { username: 'Updated Creator', email: 'Updated email', password: 'Updated password' };
//     const updatedCreator: Creator = { id: creatorId, ...creatorDto };
//     jest.spyOn(creatorService, 'update').mockResolvedValue(updatedCreator);
//     expect(await controller.updateCreator(creatorId, creatorDto)).toBe(updatedCreator);
//   });

//   it('should delete a creator', async () => {
//     const creatorId = 1;
//     const deletedCreator: Creator = { id: creatorId, username: 'Deleted Creator', email: 'Deleted email', password: 'Deleted password' };
//     jest.spyOn(creatorService, 'deleteCreator').mockResolvedValue(deletedCreator);
//     expect(await controller.deleteCreator(creatorId)).toBe(deletedCreator);
//   });
// });
